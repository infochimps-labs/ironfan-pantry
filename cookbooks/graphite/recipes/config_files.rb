#
# Carbon
#

template "#{node[:graphite][:conf_dir]}/carbon.conf" do
  mode          "0644"
  variables     :carbon    => Mash.new.merge(node[:graphite]).merge(node[:graphite][:carbon])
  notifies      :restart, "service[graphite_carbon]", :delayed if startable?(node[:graphite][:carbon])
end

template "#{node[:graphite][:conf_dir]}/storage-schemas.conf" do
  mode          "0644"
  variables     :carbon    => Mash.new.merge(node[:graphite]).merge(node[:graphite][:carbon])
  notifies      :restart, "service[graphite_carbon]", :delayed if startable?(node[:graphite][:carbon])
end

link "#{node[:graphite][:home_dir]}/conf/carbon.conf" do
  to "#{node[:graphite][:conf_dir]}/carbon.conf"
  action :create
end

link "#{node[:graphite][:home_dir]}/conf/storage-schemas.conf" do
  to "#{node[:graphite][:conf_dir]}/storage-schemas.conf"
  action :create
end

link "#{node[:graphite][:home_dir]}/lib/whisper.py" do
  to "#{node[:graphite][:prefix_dir]}/lib/whisper.py"
  action :create
end

link "#{node[:graphite][:home_dir]}/lib/whisper.pyc" do
  to "#{node[:graphite][:prefix_dir]}/lib/whisper.pyc"
  action :create
end

#
# Dashboard
#

template "#{node[:graphite][:conf_dir]}/local_settings.py" do
  mode          "0644"
  variables     :dashboard => Mash.new.merge(node[:graphite]).merge(node[:graphite][:dashboard])
  source        "dashboard-settings.py.erb"
end

link "#{node[:graphite][:home_dir]}/webapp/graphite/local_settings.py" do
  to "#{node[:graphite][:conf_dir]}/local_settings.py"
  action :create
end

# If we create the dashboard for the first time, run the sync'er
bash "sync dashboard db" do
  code          "python #{node[:graphite][:home_dir]}/webapp/graphite/manage.py syncdb"
  user          node[:graphite][:dashboard][:user]
  environment   'GRAPHITE_ROOT' => node[:graphite][:home_dir]
  cwd           node[:graphite][:home_dir]
  action        :nothing # only runs first time
end

# DB for the dashboard, used to store displays, etc -- not metrics
cookbook_file "#{node[:graphite][:data_dir]}/graphite_dashboard.db" do
  owner         node[:graphite][:dashboard][:user]
  group         node[:graphite][:dashboard][:user]
  action        :create_if_missing
  notifies      :run, "bash[sync dashboard db]", :immediately
end
