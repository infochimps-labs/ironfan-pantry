
directory node['bind']['sysconfdir'] do
  owner node['bind']['user']
  group node['bind']['group']
  mode 0750
end

template "#{node['bind']['sysconfdir']}/rndc.key" do
  source 'rndc.key.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(
    :key => node['bind']['tsigkey']
  )
end

