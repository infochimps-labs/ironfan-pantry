include_recipe 'rundeck::default'
include_recipe 'rundeck::install_from_package'
include_recipe 'rundeck::sshdir'
include_recipe 'rundeck::install_chef-rundeck'
include_recipe 'rundeck::integration_with_chef-rundeck'
include_recipe 'rundeck::ssl'
include_recipe 'rundeck::sshkey'

# Frustratingly, much of what's already been said elsewhere needs (?)
# to be said again in this script which constructs the monster Java
# command-line we ultimately wind up running to launch Rundeck.
template File.join(node[:rundeck][:conf_dir], 'profile') do
  source   'profile.erb'
  mode     '0664'
  owner    node[:rundeck][:user]
  group    node[:rundeck][:group]
  notifies :restart, 'service[rundeckd]', :immediately
end

announce(:rundeck, :server, {
  :ports   => {
    :server       => {
      :protocol => (node[:rundeck][:use_ssl] ? 'https'                     : 'http'                        ),
      :port     => (node[:rundeck][:use_ssl] ? node[:rundeck][:ssl][:port] : node[:rundeck][:server][:port])
    },
    # :chef_rundeck => { :protocol => 'http', :port => node[:rundeck][:chef_rundeck][:port] }
  },
  :logs    => {
    :server       => node[:rundeck][:log_dir],
    :chef_rundeck => node[:rundeck][:chef_rundeck][:log_dir]
  },
  :daemons => {
    :server => {
      :name => 'java',
      :user => node[:rundeck][:user],
      :cmd  => 'rundeck.RunServer'
    },
    :chef_rundeck => {
      :name => 'ruby',
      :user => node[:rundeck][:user],
      :cmd  => 'chef-rundeck'
    }
  },
  :ssh_public_key => rundeck_ssh_public_key
})
