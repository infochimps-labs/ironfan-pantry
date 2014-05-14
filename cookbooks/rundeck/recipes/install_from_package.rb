directory '/var/lib/rundeck' do
  mode '0700'
  owner 'rundeck'
  group 'rundeck'
  action :create
end

directory '/var/lib/rundeck/.ssh' do
  mode '0700'
  owner 'rundeck'
  group 'rundeck'
  action :create
end

package "rundeck"

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

