include_recipe("vayacondios_old::default")

standard_dirs "vayacondios_old" do
  # do *not* include home_dir as it is actually a symlink that will
  # be created by the install_from_git recipe below
  #
  # do *not* include log_dir as it is not required by the client, only
  # the server
  directories :deploy_root, :conf_dir
end

include_recipe("vayacondios_old::install_from_git")

vayacondios_old = discover(:vayacondios_old, :server)

Chef::Log.warn("No vayacondios_old organization is set for this node (node[:vayacondios_old][:organization]).") unless node[:vayacondios_old][:organization]

template File.join(node[:vayacondios_old][:conf_dir], "vayacondios.yml") do
  source    "vayacondios.yml.erb"
  mode      "0644"
  variables({
    :vayacondios_old  => {
       :host => vayacondios_old && vayacondios_old.private_ip,
       :port => vayacondios_old && vayacondios_old.ports[:nginx][:port],
    },
  })
end
