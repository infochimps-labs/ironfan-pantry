# -*- ruby -*-

require 'rubygems' unless defined?(Gem)
require 'bundler'
$LOAD_PATH.unshift(File.dirname(__FILE__))

Bundler.setup(:default, :development, :support)

require 'rake/tasklib'
require 'fileutils'
require 'repoman'
require 'pry'

REPOMAN_ROOT_DIR  = File.expand_path('~/ics/sysadmin/repoman')
HOMEBASE_MAIN_DIR = File.expand_path('.')
GITHUB_ORG        = 'infochimps-cookbooks'
GITHUB_TEAM       = '117089'

# * TODO: Gee this part here could serve to be a bit cleaner.
#   yes, I am in fact commenting the various collections in and out and re-running.
#   should instead use File.realdirpath and discover the .git above me.
# * TODO: Also those hardcoded values should be configurable

def get_repoman
  cookbooks = FileList['vendor/infochimps/*'].select{|d| File.directory?(d) }.sort_by{|d| File.basename(d) }.reverse
  clxn = ClusterChef::Repoman::Collection.new(
    cookbooks,
    :vendor      => 'infochimps',
    :main_dir    => HOMEBASE_MAIN_DIR,
    :solo_root   => File.join(REPOMAN_ROOT_DIR, 'solo'),
    :github_org  => GITHUB_ORG,
    :github_team => GITHUB_TEAM,
    )
  p clxn
  clxn
end

# def get_repoman
#   cookbooks = %w[
#     ant apache2 apt aws bluepill boost build-essential chef-client chef-server
#     couchdb cron daemontools database emacs erlang gecode git iptables java
#     jpackage mysql nginx ntp openssh openssl python rabbitmq rsyslog runit
#     thrift ubuntu ucspi-tcp ufw xfs xml yum zlib zsh
#  ].reverse
#   # cookbooks = cookbooks[-6..-1]
#   clxn = ClusterChef::Repoman::Collection.new(
#     cookbooks,
#     :vendor   => 'opscode',
#     :main_dir  => File.expand_path('vendor/opscode', HOMEBASE_MAIN_DIR),
#     :solo_root   => File.join(REPOMAN_ROOT_DIR, 'solo'),
#     :github_org  => GITHUB_ORG,
#     :github_team => GITHUB_TEAM,
#     )
#   clxn
# end

# def get_repoman
#   ClusterChef::Repoman::Collection.new(['zabbix'],  :vendor => 'laradji', :main_dir => nil, :github_org  => GITHUB_ORG, :github_team => GITHUB_TEAM )
# end

# def get_repoman
#   ClusterChef::Repoman::Collection.new(['rvm'],     :vendor => 'fnichol', :main_dir => nil, :github_org  => GITHUB_ORG, :github_team => GITHUB_TEAM )
# end

# repoman = get_repoman
# repoman.each_repo{|r| r.define_tasks }

def get_repo(repo_name)
  repoman  = get_repoman
  repo     = repoman.repo(repo_name)
  raise "Can't find repo #{repo_name}: only know about #{repoman.repo_names}" unless repo
  [repoman, repo]
end

def check_args(rt, args)
  missing = rt.arg_names.select{|arg| args.send(arg).blank? }
  raise ArgumentError, "Please supply #{missing.join(', ')}: 'rake #{rt.name}#{rt.arg_description}'" unless missing.empty?
end

def banner(rt, args, repo)
  puts "\n== #{"%-15s" % rt.name}\trepo #{"%-15s" % repo.name}\tpath #{repo.path}\n"
end


namespace :repo do

  namespace :solo do
    desc 'repo mgmt: clone repos from github'
    task :create

    desc 'repo mgmt: pull to solo from main'
    task :pull_from_main

    desc 'repo mgmt: pull to solo from github'
    task :pull_from_github

    desc 'repo mgmt: push from solo to github'
    task :push_to_github
  end

  desc "repo mgmt: safely sync each repo and pull the results into this repo"
  task :pull, [:repo_name] do |rt, args|
    if args.repo_name
      repoman.repo(args.repo_name).sync_and_pull.invoke
    else
      task("repo:pull:all").invoke
    end
  end

  desc "repo mgmt: safely sync each repo and pull the results into this repo"
  task :push, [:repo_name] do |rt, args|
    if args.repo_name
      repoman.repo(args.repo_name).sync_and_push.invoke
    else
      task("repo:push:all").invoke
    end
  end

  # namespace :main do
  #   desc 'repo mgmt: pull to main from solo'
  #   task :pull_from_solo
  #
  #   desc 'repo mgmt: split subtree commits into their own branch'
  #   task :subtree_split
  # end
  #
  # desc 'repo mgmt: ensure all github targets exist'
  # task :add_subtree_hack do |rt, args|
  #   check_args(rt, args)
  #   repoman = get_repoman
  #   repoman.subtree_add_all
  # end
  #
  # desc 'repo mgmt: ensure all github targets exist'
  # task :gh do |rt, args|
  #   check_args(rt, args)
  #   repoman = get_repoman
  #   repoman.each_repo do |repo|
  #     banner(rt, args, repo)
  #
  #     # FIXME: restore
  #     # repo.github_create
  #
  #   end
  # end
  #
  # desc 'repo mgmt: extract subtree split'
  # task :subtree => [:gh] do |rt, args|
  #   check_args(rt, args)
  #   repoman = get_repoman
  #   repoman.in_main_tree do
  #     repoman.each_repo do |repo|
  #       banner(rt, args, repo)
  #       repo.git_subtree_split
  #     end
  #   end
  # end
  #
  # desc 'repo mgmt: sync solo with tree'
  # task :solo => [:gh] do |rt, args|
  #   check_args(rt, args)
  #   repoman = get_repoman
  #   repoman.each_repo do |repo|
  #     banner(rt, args, repo)
  #     repo.create_solo.invoke
  #   end
  # end
  #
  # task :push => [
  #   # :gh, :solo, :subtree
  # ] do |rt, args|
  #   check_args(rt, args)
  #   repoman = get_repoman
  #   repoman.in_main_tree do
  #     repoman.each_repo do |repo|
  #       banner(rt, args, repo)
  #       repo.pull_to_solo_from_main.invoke
  #       repo.push_from_solo_to_github.invoke
  #     end
  #   end
  # end
  #
  # task :pull => [
  #   # :gh, :solo, :subtree
  # ] do |rt, args|
  #   check_args(rt, args)
  #   repoman = get_repoman
  #   repoman.in_main_tree do
  #     repoman.each_repo do |repo|
  #       banner(rt, args, repo)
  #       repo.pull_to_solo_from_main.invoke
  #       repo.pull_to_solo_from_github.invoke
  #       repo.pull_to_main_from_solo.invoke
  #     end
  #   end
  # end
  #
  # #
  # # Manage the github repos
  # #
  # namespace :gh do
  #   desc 'repo mgmt: github target repo information'
  #   task :show, [:repo_name] do |rt, args|
  #     check_args(rt, args)
  #     repoman, repo = get_repo(args.repo_name)
  #     info = repo.github_info
  #     puts JSON.pretty_generate(info)
  #   end
  #
  #   desc 'repo mgmt: create github target repo'
  #   task :sync, [:repo_name] do |rt, args|
  #     check_args(rt, args)
  #     repoman, repo = get_repo(args.repo_name)
  #     repo.github_sync
  #   end
  #
  #   desc 'repo mgmt: ensure all github targets exist'
  #   task :sync_all do |rt, args|
  #     check_args(rt, args)
  #     repoman = get_repoman
  #     repoman.each_repo do |repo|
  #       banner(rt, args, repo)
  #       repo.github_sync
  #     end
  #   end
  #
  #   desc 'repo mgmt: delete github target repo. must set the REPOMAN_LOOK_IN_TRUNK environment variable.'
  #   task :whack, [:repo_name] do |rt, args|
  #     check_args(rt, args)
  #     repoman, repo = get_repo(args.repo_name)
  #     info = repo.github_delete!
  #     Log.info("whacked #{repo.name}")
  #   end
  # end

end
