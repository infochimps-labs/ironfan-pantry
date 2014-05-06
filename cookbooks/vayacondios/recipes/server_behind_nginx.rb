include_recipe("vayacondios::default")

daemon_user "vayacondios.server"

standard_dirs "vayacondios.server" do
  # do *not* include home_dir as it is actually a symlink that will
  # be created by the install_from_git recipe below
  directories :deploy_root, :log_dir, :conf_dir, :tmp_dir
end
include_recipe("vayacondios::install_from_git")

mongo = discover(:mongodb, :server)

Chef::Log.warn("No MongoDB database is set for Vayacondios server to write to (didn't set and couldn't discover node[:vayacondios][:mongodb][:database])") unless node[:vayacondios][:mongodb][:database]

sockets = []
logs    = {}
daemons = {}
node[:vayacondios][:server][:num_daemons].times do |i|

  aspect       = "goliath_#{i}".to_sym
  service      = "vayacondios_#{i}"
  log_dir      = File.join(node[:vayacondios][:log_dir], i.to_s)
  socket       = File.join(node[:vayacondios][:tmp_dir], "goliath-#{i}.sock")
  
  sockets << socket
  
  directory log_dir do
    owner  node[:vayacondios][:user]
    group  node[:vayacondios][:group]
    mode   '0775'
    action :create
  end
  
  runit_service "vayacondios_#{i}" do
    template_name "vayacondios"
    options({
      log_dir:    log_dir,
      socket:     socket,
      host:       mongo && mongo.private_ip,
      mongo_port: mongo && mongo.ports[:http][:port],
    })
  end

  daemons[aspect] = {
    :service => service,
    :name => 'ruby',
    :user => node[:vayacondios][:user],
    :cmd  => "goliath-#{i}.sock"
  }
  logs[aspect]    = ::File.join(log_dir,"current")
end

template File.join(node[:nginx][:dir], 'sites-available', 'vayacondios.conf') do
  source    'vayacondios.nginx.conf.erb'
  mode      '0644'
  action    :create
  variables :sockets => sockets
  notifies  :restart, "service[nginx]", :delayed
end

nginx_site "vayacondios.conf" do
  action :enable
end

logs[:nginx_access] = { path: File.join(node[:vayacondios][:log_dir], "nginx.access.log") }
logs[:nginx_error] = { path: File.join(node[:vayacondios][:log_dir], "nginx.error.log") }

announce(:vayacondios, :server,
  :ports => {
    :http => {
      :port     => node[:vayacondios][:server][:port],
      :protocol => 'http'
    },
  },
  :daemons => daemons,
  :logs    => logs,
)

