node.set[:hive  ][:metastore  ][:host] = discover(:hive, :metastore).private_ip     rescue nil
node.set[:impala][:catalog    ][:host] = discover(:impala, :catalog).private_ip     rescue nil
node.set[:impala][:state_store][:host] = discover(:impala, :state_store).private_ip rescue nil

template_variables = {
  impala: node[:impala],
  hive:   node[:hive],
  hadoop: node[:hadoop],
  hue:    node[:hue],
}

if node[:hive] && node[:hive][:conf_dir]
  # Need the hive-site.xml
  link File.join(node[:impala][:conf_dir], 'hive-site.xml') do
    to      File.join(node[:hive][:conf_dir], 'hive-site.xml')
    only_if "test -f #{File.join(node[:hive][:conf_dir], 'hive-site.xml')}"
  end
else
  # Need to create hive.xml on non-hive nodes
end

# Need the hdfs-site.xml
link File.join(node[:impala][:conf_dir], 'hdfs-site.xml') do
  to      File.join(node[:hadoop][:conf_dir], 'hdfs-site.xml')
  only_if "test -f #{File.join(node[:hadoop][:conf_dir], 'hdfs-site.xml')}"
end

# Need the core-site.xml
link File.join(node[:impala][:conf_dir], 'core-site.xml') do
  to      File.join(node[:hadoop][:conf_dir], 'core-site.xml')
  only_if "test -f #{File.join(node[:hadoop][:conf_dir], 'core-site.xml')}"
end

template '/etc/default/impala' do
  owner     'root'
  mode      '0644'
  source    'etc_default_impala.erb'
  variables template_variables
  notify_startable_services(:impala, [:server, :state_store])
end

template File.join(node[:impala][:conf_dir], 'impala-env.sh') do
  mode      '0644'
  source    'impala-env.sh.erb'
  variables template_variables
  notify_startable_services(:impala, [:server, :state_store])
end
