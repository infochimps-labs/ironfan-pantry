#
# Cookbook Name:: storm
# Description:: Automatically configure Storm clusters
# Recipe:: config_files
#

# raise "Exactly 1 storm_master is required per cluster!" if discover_all(:storm, :master).length != 1

include_recipe 'silverware'

volume_dirs('storm.data') do
  type          :persistent
  selects       :single
  path          'nimbus'
end

template File.join(node[:storm][:home_dir], 'conf/storm.yaml') do
  owner  node[:storm][:user]
  group  node[:storm][:group]
  mode   "0644"
  source "storm.yaml.erb"
  Chef::Log.warn("Storm was not provided a volume to store data to. Defaulting to /var/storm")
  variables({
    :ports => node[:storm][:worker][:processes].times.map{ |i| node[:storm][:worker][:start_port] + i },
    :zookeepers => discover_all(:zookeeper, :server).sort_by{|cp| cp.node[:facet_index] },
    :nimbus => discover(:storm, :master),
    :data_dir => node[:storm][:data_dir] || '/var/storm'
  })
  notifies  :restart, "service[storm_master]", :delayed if startable?(node[:storm][:master]) && node.facet_name == 'master'
  notifies  :restart, "service[storm_worker]", :delayed if startable?(node[:storm][:worker]) && node.facet_name == 'worker'
end

template File.join(node[:storm][:home_dir], 'log4j/storm.log.properties') do
  owner  node[:storm][:user]
  group  node[:storm][:group]
  mode   "0644"
  source "storm.log.properties.erb"
  notifies  :restart, "service[storm_master]", :delayed if startable?(node[:storm][:master]) && node.facet_name == 'master'
  notifies  :restart, "service[storm_worker]", :delayed if startable?(node[:storm][:worker]) && node.facet_name == 'worker'
  # for storm 0.9.0, which uses logbak rather than log4j.
  only_if{ File.exists? File.join(node[:storm][:home_dir], 'log4j')}
end
