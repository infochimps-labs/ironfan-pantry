include_recipe 'rundeck::default'

rundeck_server = discover(:rundeck, :server)
if rundeck_server
  ssh_public_key = (rundeck_server.node[:announces]["#{discovery_realm(:rundeck, :server)}-rundeck-server"][:info][:ssh_public_key] rescue nil)
  if ssh_public_key
    file File.join(node[:rundeck][:pid_dir], '.ssh/authorized_keys') do
      mode    '0600'
      owner   node[:rundeck][:user]
      group   node[:rundeck][:group]
      content ssh_public_key
    end
    # Grant the rundeck user sudo...
  else
    Chef::Log.warn("Rundeck server #{rundeck_server.fullname} did not announce an SSH public key")
  end
end


