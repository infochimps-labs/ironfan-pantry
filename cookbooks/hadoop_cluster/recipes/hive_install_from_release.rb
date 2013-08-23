include_recipe 'install_from'


#
# Install Hive from latest release
#
#   puts Hive tarball into /usr/local/src/pig-xxx
#   expands it into /usr/local/share/pig-xxx
#   and links that to /usr/local/share/pig
#

install_from_release('hive') do
  release_url   node[:hive][:release_url]
  version       node[:hive][:version]
  home_dir      node[:hadoop][:hive][:home_dir]
  action        [:install]
  environment('JAVA_HOME' => node[:java][:java_home]) if node[:java][:java_home]
end

# link the <home>/conf to the desired conf dir
directory node[:hadoop][:hive][:conf_dir] do
  action :delete
  only_if do !File.symlink?(node[:hadoop][:hive][:conf_dir]) end
end

directory node[:hadoop][:hive][:conf_base_dir] do
  recursive true
  action :create
  only_if do !File.exists?(node[:hadoop][:hive][:conf_base_dir]) end
end

link File.join(node[:hadoop][:hive][:conf_base_dir], 'conf') do
  to          File.join(node[:hadoop][:hive][:home_dir],'conf')      
  action      :create
  only_if do !File.exists?(File.join(node[:hadoop][:hive][:conf_base_dir], 'conf')) end
end

template "/usr/bin/hive" do
  owner       "root"
  mode        "0755"
  source      "hive.erb"
end

remote_file(File.join(node[:hadoop][:hive][:home_dir], node[:hadoop][:hive][:mysql_connector_jar])) do
  source node[:hadoop][:hive][:mysql_connector_location]
end
