volume_dirs('storm.data') do
  type      :persistent
  selects   :single
  path      'nimbus'
end

node.set[:storm][:nimbus]     = discover(:storm, :master)
node.set[:storm][:zookeepers] = discover_all(:zookeeper, :server)

template File.join(node[:storm][:conf_dir], 'storm.yaml') do
  owner     node[:storm][:user]
  group     node[:storm][:group]
  mode      '0644'
  source    'storm.yaml.erb'
  variables(storm: node[:storm])
  notify_startable_services(:storm, [:master, :worker])
end

template File.join(node[:storm][:home_dir], 'log4j/storm.log.properties') do
  owner     node[:storm][:user]
  group     node[:storm][:group]
  mode      '0644'
  source    'storm.log.properties.erb'
  only_if   "test -d #{File.join(node[:storm][:home_dir], 'log4j')}"
  notify_startable_services(:storm, [:master, :worker])
end
