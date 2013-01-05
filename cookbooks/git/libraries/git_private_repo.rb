class Chef
  class Recipe

    def git_ssh_wrapper_path_for repo_name
      File.join("/etc/deploy/", repo_name, "#{repo_name}.sh")
    end
    
  end
end
