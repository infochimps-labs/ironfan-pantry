# FIXME -- this should be refactored into a resource/provider pair

org = node[:organization]

[org, "#{org}/etc", "#{org}/var"].each do |path|
  directory File.join(node[:rundeck][:data_dir], path) do
    mode      '0775'
    owner     node[:rundeck][:user]
    group     node[:rundeck][:group]
    recursive true
  end
end

template File.join(node[:rundeck][:data_dir], "#{org}/etc/project.properties") do
  source   'integration.properties.erb'
  mode     '0664'
  owner    node[:rundeck][:user]
  group    node[:rundeck][:group]
  notifies :restart, :service => 'rundeckd'
end
