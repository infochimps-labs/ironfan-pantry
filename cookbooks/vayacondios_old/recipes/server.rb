include_recipe("vayacondios_old::default")

daemon_user "vayacondios_old.server"

standard_dirs "vayacondios_old.server" do
  # do *not* include home_dir as it is actually a symlink that will
  # be created by the install_from_git recipe below
  directories :deploy_root, :log_dir, :conf_dir, :tmp_dir
end
include_recipe("vayacondios_old::install_from_git")

mongo = discover(:mongodb, :server)

Chef::Log.warn("No MongoDB database is set for vayacondios_old server to write to (didn't set and couldn't discover node[:vayacondios_old][:mongodb][:database])") unless node[:vayacondios_old][:mongodb][:database]

sockets = []
logs    = {}
daemons = {}
node[:vayacondios_old][:server][:num_daemons].times do |i|

  aspect       = "goliath_#{i}".to_sym
  service      = "vayacondios_old_#{i}"
  log_dir      = File.join(node[:vayacondios_old][:log_dir], i.to_s)
  socket       = File.join(node[:vayacondios_old][:tmp_dir], "goliath-#{i}.sock")

  sockets << socket

  directory log_dir do
    owner  node[:vayacondios_old][:user]
    group  node[:vayacondios_old][:group]
    mode   '0775'
    action :create
  end

  runit_service "vayacondios_old_#{i}" do
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
    :user => node[:vayacondios_old][:user],
    :cmd  => "goliath-#{i}.sock"
  }
  logs[aspect]    = ::File.join(log_dir,"current")
end

include_recipe "nginx"

template File.join(node[:nginx][:dir], 'sites-available', 'vayacondios_old.conf') do
  source    'vayacondios.nginx.conf.erb'
  mode      '0644'
  action    :create
  variables :sockets => sockets
  notifies  :restart, "service[nginx]", :delayed
end

nginx_site "vayacondios_old.conf" do
  action :enable
end

logs[:nginx_access] = { path: File.join(node[:vayacondios_old][:log_dir], "nginx.access.log") }
logs[:nginx_error] = { path: File.join(node[:vayacondios_old][:log_dir], "nginx.error.log") }

announce(:vayacondios_old, :server,
  :ports => {
    :nginx => {
      :port     => node[:vayacondios_old][:server][:port],
      :protocol => 'http'
    },
  },
  :daemons => daemons,
  :logs    => logs,
)
