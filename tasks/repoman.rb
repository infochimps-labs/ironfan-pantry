$LOAD_PATH.unshift(File.expand_path('lib'))

require 'chef/log' ; ::Log = Chef::Log
require 'gorillib/logger/log'

require 'json'
require 'chef/mash'
require 'gorillib/metaprogramming/class_attribute'
require 'gorillib/hash/reverse_merge'
require 'gorillib/object/blank'
require 'gorillib/hash/compact'
require 'set'
require 'cluster_chef/dsl_object'
require 'rest-client'
require 'grit'

require 'repoman/github'

# def Log.dump(*args) self.debug([args.map(&:inspect), caller.first ].join("\t")) ;end
# Log.level = :info
# Log.level = :debug ; RestClient.log = Log

module ClusterChef
  module Repoman

    class Collection < ClusterChef::DslObject
      include ::Rake::Cloneable
      include ::Rake::DSL
      attr_reader :repos
      has_keys(
        :solo_root,          # holds the solo/ versions of the repo
        :main_dir,           # the local checkout to mine
        :vendor              # direectory within vendor/ to target inside homebase
        )

      def initialize(paths, hsh={}, &block)
        super(hsh, &block)
        defaults
        @repos = Mash.new
        paths.each do |path|
          repo = ClusterChef::Repoman::Repo.new(self, path, hsh)
          @repos[repo.name] = repo
        end
      end

      def defaults
      end

      #
      # Locations
      #

      # repo object for each subtree under management
      def repo(repo_name)
        @repos[repo_name]
      end
      # names for each known repo
      def repo_names
        @repos.keys
      end
      def each_repo
        @repos.values.each{|repo| yield(repo) }
      end

      def subtree_add_all
        cd File.expand_path('~/ics/sysadmin/homebase') do
          each_repo do |repo|
            file("vendor/#{vendor}/#{repo.name}") do
              puts "#{repo.name} subtreeing"
              sh("git", "subtree", "add", "-P", "vendor/#{vendor}/#{repo.name}", File.join(repo.solo_dir, '.git'), "master")
            end
            file("cookbooks/#{repo.name}"){ symlink("../vendor/#{vendor}/#{repo.name}", "cookbooks") }
            task("add_subtree_#{repo.name}" => ["vendor/#{vendor}/#{repo.name}", "cookbooks/#{repo.name}"]).invoke
          end
        end
      end
      
      # convert to string, but mask the token
      def to_s()
        "#{super[0..-3]} repos=#{@repos.values.map(&:name).inspect} >"
      end
    end


    class Repo < ClusterChef::DslObject
      include ::Rake::Cloneable
      include ::Rake::DSL

      include ClusterChef::Repoman::GithubRepo

      attr_reader :collection  # collection this belongs to
      attr_reader :path        # path within main repo
      attr_reader :shas        # shas for various incarnations
      has_keys(
        :name,
        :push_urlbase,       # base url for target repo names, eg git@github.com:infochimps-cookbooks
        :main_dir,           # the local checkout to mine
        :github_api_urlbase, # github API url base
        :github_org,         # github organization, eg 'infochimps-cookbooks'
        :github_team,        # github team to authorize for the repo
        :github_username,    # github username
        :github_token,       # github token
        :github_public       # is the repo public or private?
        )

      def initialize(collection, path, hsh={}, &block)
        super(hsh)
        @collection = collection
        @path       = path
        @shas       = {}
        name(File.basename(path))
        defaults

        yield self if block_given?
        arg_names = [:name]
        missing = arg_names.select{|arg| self.send(arg).blank? }
        raise ArgumentError, "Please supply #{missing.join(', ')} in #{self}" unless missing.empty?
      end

      def defaults
        @settings[:github_api_urlbase] ||= 'https://github.com/api/v2/json'
        @settings[:push_urlbase]       ||= "git@github.com:"
        find_github_credentials
      end

      def define_tasks
        # task "repo:solo:pull_from_github" => pull_to_solo_from_github
        # task "repo:solo:push_to_github"   => push_from_solo_to_github
        # task "repo:solo:pull_from_main"   => pull_to_solo_from_main
        # task "repo:main:pull_from_solo"   => pull_to_main_from_solo
        # task "repo:main:subtree_split"    => subtree_split
        task("repo:pull:all" => sync_and_pull)
        task("repo:push:all" => sync_and_push)
      end

      # Directory holding the solo repo
      def solo_dir()   File.join(collection.solo_root, name)  end
      # if this file is present the repo is assumed to exist
      def solo_repo_presence() File.join(solo_dir, '.git', 'HEAD') end

      def branch_name
        "br-#{name}"
      end

      def main_branch
        main_repo.branches.detect{|branch| branch.name == branch_name }
      end

      def main_repo
        @main_repo ||= Grit::Repo.new(main_dir)
      end

      #
      # Solo repo (non-bare local checkout of the repo)
      #

      def sync_and_pull
        return @sync_and_pull if @sync_and_pull
        desc "Safely sync the #{name} repo and pull the results into #{main_dir}"
        @sync_and_pull ||= task("repo:pull:#{name}" =>
          [create_solo, pull_to_solo_from_main, pull_to_solo_from_github, pull_to_main_from_solo])
      end

      def sync_and_push
        return @sync_and_push if @sync_and_push
        desc "Safely sync the #{name} repo and push the results into #{github_repo_url}"
        @sync_and_push ||= task("repo:push:#{name}" =>
          [create_solo, pull_to_solo_from_github, pull_to_solo_from_main, push_from_solo_to_github])
      end

      def create_solo
        return @create_solo_task if @create_solo_task
        directory(File.dirname(solo_dir))
        file(solo_repo_presence) do
          cd(File.dirname(solo_dir)){ sh('git', 'clone', github_repo_url) }
        end
        desc "Clone the #{name} repo from github"
        @create_solo_task = task("repo:solo:create:#{name}" => [File.dirname(solo_dir), solo_repo_presence])
      end

      def pull_to_solo_from_github
        @pull_to_solo_from_github ||= task("repo:solo:pull_from_github:#{name}" => create_solo) do
          cd(solo_dir){ sh('git', 'pull', "origin", "master:master") }
        end
      end

      def push_from_solo_to_github
        @push_from_solo_to_github ||= task("repo:solo:push_to_github:#{name}" => create_solo) do
          cd(solo_dir){ sh('git', 'push', "origin", "master:master") }
        end
      end

      def pull_to_solo_from_main
        @pull_to_solo_from_main ||= task("repo:solo:pull_from_main:#{name}" => [create_solo, subtree_split]) do
          cd(solo_dir){ sh('git', 'pull', "#{main_dir}/.git", "#{branch_name}:master") }
        end
      end

      def pull_to_main_from_solo
        @pull_to_main_from_solo ||= task("repo:main:pull_from_solo:#{name}" => [create_solo, subtree_split]) do
          in_main_tree do
            # sh('git', 'pull', "#{solo_dir}/.git", "master:#{branch_name}")
            Log.debug("Pulling subtree for #{name} from #{solo_dir} into #{main_dir}")
            sh( "git-subtree", "pull",
              "-P", path,
              "#{solo_dir}/.git", "master:#{branch_name}",
              "-m", "Merge branch 'master' of #{github_repo_name} into #{path}"
              ){|ok, status| Log.debug("status #{status}") }
          end
        end
      end

      # Extract git history from component's local path into its own branch in
      # this repo. For example, Repo.new(clxn, 'hadoop_cluster').git_split
      # creates a branch 'hadoop_cluster' with only the commits in the
      # cookbooks/hadoop_cluster file tree. If you +git checkout
      # hadoop_cluster+, you'll have only subdirectories named 'recipes',
      # 'templates', etc. -- it'the contents of the single target repo.
      def subtree_split
        @subtree_split ||= task("repo:main:subtree_split:#{name}") do
          in_main_tree do
            shas[:sr_before] = main_branch.commit.to_s rescue nil
            Log.debug("Extracting subtree for #{name} from #{path} in #{main_dir}; was at #{shas[:sr_before] || '()'}")
            sh( "git-subtree", "split", "-P", path, "-b", branch_name ){|ok, status| Log.debug("status #{status}") }
            shas[:sr_after] = main_branch.commit.to_s rescue nil
          end
        end
      end
      
      #
      # other
      #

      def in_main_tree
        raise "Repo dirty. Too terrified to move.\n#{filth}" unless clean?
        cd main_dir do
          sh("git", "checkout", "public")
          yield
        end
      end

      def clean?
        st = main_repo.status
        st.changed.empty? && st.added.empty? && st.deleted.empty?
      end
      def filth
        st = main_repo.status
        [ "  changed   #{  st.changed.values.map(&:path).join(', ')}",
          "  added     #{    st.added.values.map(&:path).join(', ')}",
          "  deleted   #{  st.deleted.values.map(&:path).join(', ')}",
          # "  untracked #{st.untracked.values.map(&:path).join(', ')}",
        ].join("\n")
      end

      # convert to string, but mask the token
      def to_s()
        super.gsub(/(github_token"=>"....)[^"]+"/,'\1....."')
      end

    end
  end
end
