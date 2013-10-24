directory '/usr/local/src' do
  mode      '0777'
  recursive true
  action    :create
end
deb_src        = node[:rundeck][:release_url].gsub(/:version:/,node[:rundeck][:version])
downloaded_deb = "/usr/local/src/rundeck-#{node[:rundeck][:version]}.deb"

bash "Install Rundeck" do
  code   "dpkg --install #{downloaded_deb}"
  action :nothing
end

remote_file downloaded_deb do
  source   deb_src
  notifies :run, resources(:bash => 'Install Rundeck'), :immediately  
end

service "rundeckd" do
  supports :status => true
end

[ 'framework.properties',  # alter basic parameters, like ports
  'realm.properties',      # rebuild the user table
  'log4j.properties',      # logging
  'project.properties'     # managing projects
].each do |basename|
  template File.join(node[:rundeck][:conf_dir], basename) do
    owner    node[:rundeck][:owner]
    group    node[:rundeck][:group]
    source   "#{basename}.erb"
    mode     '0660'
    notifies :restart, :service => 'rundeckd'
  end
end
