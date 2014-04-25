include_recipe 'vayacondios::default'

standard_dirs 'vayacondios.client' do
  directories :conf_dir
end

vayacondios = discover(:vayacondios, :server)

Chef::Log.warn "This is the vayacondios you have discovered: #{vayacondios ? vayacondios.private_ip : nil}"

Chef::Log.warn("No Vayacondios organization is set for this node (node[:vayacondios][:organization]).") unless node[:vayacondios][:organization]

template File.join(node[:vayacondios][:client][:conf_dir], 'vayacondios.yml') do
  source    'vayacondios.yml.erb'
  mode      '0644'
  variables(
    host: vayacondios && vayacondios.private_ip,
    port: vayacondios && vayacondios.ports[:http][:port],
  )
end
