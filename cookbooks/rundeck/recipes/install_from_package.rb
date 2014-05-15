
# Somehow /var/lib/rundeck and /var/lib/rundeck/.ssh get installed for
# root:rundeck instead of rundeck:rundeck.  Try setting too-open perms
# (770) now so package[rundeck] can write to it, then locking down to
# 700.
directory '/var/lib/rundeck' do
  mode '0770'
  owner 'rundeck'
  group 'rundeck'
  action :create
end
directory '/var/lib/rundeck/.ssh' do
  mode '0770'
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

