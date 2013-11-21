class Chef
  class Recipe

    def rundeck_ssh_private_key_path
      File.join(node[:rundeck][:home_dir], '.ssh/id_rsa')
    end
    
    def rundeck_ssh_public_key_path
      "#{rundeck_ssh_private_key_path}.pub"
    end

    def rundeck_ssh_public_key
      if File.exist?(rundeck_ssh_public_key_path)
        File.read(rundeck_ssh_public_key_path)
      else
        Chef::Log.warn("Cannot read SSH public key for Rundeck yet, not created")
        nil
      end
    end
    
  end
end
