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

directory node[:vayacondios][:log_dir] do
  owner  node[:vayacondios][:user]
  group  node[:vayacondios][:group]
  mode   '0775'
  action :create
end

runit_service "vayacondios" do
  template_name "vayacondios"
  options({
            log_dir:    node[:vayacondios][:log_dir],
            port:       node[:vayacondios][:server][:port],
            host:       mongo && mongo.private_ip,
            mongo_port: mongo && mongo.ports[:http][:port],
          })
end

announce(:vayacondios, :server,
  :ports => {
    :http => {
      :port     => node[:vayacondios][:server][:port],
      :protocol => 'http'
    },
  },
  :daemons => {:server => {:service => :vayacondios}},
  :logs    => {:server => ::File.join(node[:vayacondios][:log_dir], "current")}
)
