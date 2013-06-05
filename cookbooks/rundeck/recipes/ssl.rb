ssl_dir = File.join(node[:rundeck][:conf_dir], 'ssl')

directory ssl_dir do
  mode      '0770'
  owner     node[:rundeck][:user]
  group     node[:rundeck][:group]
  recursive true
end

bash "Build Rundeck's SSL keystore & truststore" do
  org_unit      = node[:rundeck][:ssl][:org_unit]
  org           = node[:rundeck][:ssl][:org]
  pass          = node[:rundeck][:ssl][:password] 

  cwd ssl_dir
  code <<-EOH
    echo -e "#{org_unit}.#{org}\n#{org_unit}\n#{org}\n\n\n\ny" | \
      keytool -keystore keystore -alias rundeck -genkey -keyalg RSA \
      -keypass #{pass} -storepass #{pass}
    cp keystore truststore
  EOH
  creates "#{ssl_dir}/keystore"
end
[ "#{ssl_dir}/keystore", "#{ssl_dir}/truststore",].each do |filename|
  file filename do
    mode  '0600'
    owner node[:rundeck][:user]
    group node[:rundeck][:group]
  end
end
# package 'authbind'            # Allow rundeck to bind low ports (for :443)

template File.join(ssl_dir, 'ssl.properties') do
  source   'ssl.properties.erb'
  mode     '0660'
  owner    node[:rundeck][:user]
  group    node[:rundeck][:group]
  notifies :restart, :service => 'rundeckd'
end
