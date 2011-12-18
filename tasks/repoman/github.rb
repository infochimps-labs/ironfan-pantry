module ClusterChef
  module Repoman
    module GithubRepo

      #
      # Github: Attributes
      #

      def github_repo_name
        "#{github_org}/#{name}"
      end
      def github_repo_url
        "#{push_urlbase}#{github_repo_name}.git"
      end
      def public?
        (github_public.to_s != "false") && (github_public.to_s != '0')
      end

      #
      # Actions
      #

      # Hash of info about the repo on github
      def github_info
        github_api_get("repos/show/#{github_repo_name}")
      end

      def github_sync
        info = {}
        info[:create] = github_create
        info[:auth  ] = github_add_teams
        info[:update] = github_update
        Log.info("synced #{name}")
        info
      end

      # Create the repo if it doesn't exist
      def github_create
        Log.debug("Creating #{name}")
        github_api_post("repos/create",
          :name   => github_repo_name, :public => (public? ? '1' : '0') ) do |*args, &block|
          harmless(:create, 422, *args, &block)
        end
      end

      def github_update
        Log.debug("Updating #{name} metadata")
        github_api_post("repos/show/#{github_repo_name}",
          :name   => github_repo_name,
          :values => {
            :homepage => "http://github.com/infochimps-labs/cluster_chef-homebase",
            :has_wiki   => "0",
            :has_issues => "0",
            :has_downloads => "1",
            :description => "#{name} chef cookbook - automatically installs and configures #{name}",
          })
      end

      def github_add_teams
        Log.debug("Authorizing team #{github_team} on #{name}")
        github_api_post("teams/#{github_team}/repositories",
          :name => github_repo_name)
      end

      def github_delete!
        response = github_api_post("repos/delete/#{github_repo_name}") do |*args, &block|
          harmless(:delete, 404, *args, &block)
        end
        del_tok = response['delete_token']
        if   not del_tok
          Log.warn "No delete token, Skipping delete"
          {:skipping => true }
        elsif not ENV['REPOMAN_LOOK_IN_TRUNK']
          Log.warn "Not deleting repo #{name} at #{github_repo_url}. Set environment variable REPOMAN_LOOK_IN_TRUNK=true to actually delete"
          {:skipping => true }
        else
          Log.warn "Deleting repo #{name} at #{github_repo_url}"
          github_api_post("repos/delete/#{github_repo_name}", :delete_token => del_tok)
        end
      end

      #
      # Helpers
      #

      #
      # Github
      #

      def find_github_credentials
        return if github_username.present? && github_token.present?
        self.github_username( ENV['GITHUB_USERNAME'] || `git config --get github.user` )
        self.github_username.strip!
        self.github_token( ENV['GITHUB_TOKEN']    || `git config --get github.token` )
        self.github_token.strip!
        if github_username.blank? || github_token.blank?
          raise ("Please set your github username (got #{github_username}) and token (got #{github_token}): either as environment variables GITHUB_USERNAME and GITHUB_TOKEN, OR in your ~/.gitconfig like so:\n\n[github]\n    user  = mrflip\n    token = 8675309beefcafe123456abcadaba123\n")
        end
      end

      def github_api_post(url_path, hsh={}, &block)
        url_path = "#{github_api_urlbase}/#{url_path}"
        hsh      = hsh.merge(:login => github_username, :token => github_token)
        response = RestClient.post(url_path, hsh, &block)
        return JSON.parse(response.to_str)
      end

      def github_api_get(url_path, hsh={})
        url_path = "#{github_api_urlbase}/#{url_path}"
        Log.dump(url_path, hsh)
        hsh = hsh.merge(:login => github_username, :token => github_token)
        response = RestClient.get(url_path, hsh)
        return JSON.parse(response.to_str)
      end

      def harmless(action, ok_codes, resp, req, result, &block)
        if Array(ok_codes).include?(resp.code)
          Log.debug("Github repo #{github_repo_name} doesn't need #{action} (#{resp.to_s}), skipping")
          resp
        else
          resp.return!(req, result, &block)
        end
      end
    end
  end
end
