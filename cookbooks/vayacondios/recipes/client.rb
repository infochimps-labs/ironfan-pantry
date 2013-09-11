include_recipe("vayacondios::default")

standard_dirs "vayacondios" do
  # do *not* include home_dir as it is actually a symlink that will
  # be created by the install_from_git recipe below
  #
  # do *not* include log_dir as it is not required by the client, only
  # the server
  directories :deploy_root, :conf_dir
end

include_recipe("vayacondios::install_from_git")

vayacondios = discover(:vayacondios, :server)

Chef::Log.warn("No Vayacondios organization is set for this node (node[:vayacondios][:organization]).") unless node[:vayacondios][:organization]

template File.join(node[:vayacondios][:conf_dir], "vayacondios.yml") do
  source    "vayacondios.yml.erb"
  mode      "0644"
  variables({
    :vayacondios  => {
       :host => vayacondios && vayacondios.private_ip,
       :port => vayacondios && vayacondios.ports[:nginx][:port],
    },
  })
end
