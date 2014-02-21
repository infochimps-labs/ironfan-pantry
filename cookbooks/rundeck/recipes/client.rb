# FIXME: home should be /var/lib/rundeck not :home_dir
# FIXME: perms must be set right on /var/lib/rundeck and .ssh

unless system "id -u rundeck" #if the rundeck user has running processes, daemon_user will fail
  daemon_user :rundeck do
    home         node[:rundeck][:home_dir]
    manage_home  true             # rundeck owns this so it can manage its own SSH credentials
    shell        '/bin/bash'
    comment      'Rundeck user'
  end
end

include_recipe 'rundeck::default'
include_recipe 'rundeck::sshdir'

rundeck_server = discover(:rundeck, :server)
if rundeck_server
  ssh_public_key = (rundeck_server.node[:announces]["#{discovery_realm(:rundeck, :server)}-rundeck-server"][:info][:ssh_public_key] rescue nil)  
  if ssh_public_key
    file File.join(node[:rundeck][:home_dir], '.ssh/authorized_keys') do
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

template '/etc/sudoers.d/rundeck' do
  source 'etc-sudoers.d-rundeck.erb'
  mode   '0440'
  owner  'root'
  group  'root'
end

