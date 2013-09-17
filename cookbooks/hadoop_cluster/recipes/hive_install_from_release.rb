include_recipe 'install_from'

install_from_release('hive') do
  release_url   node[:hadoop][:hive][:release_url]
  version       node[:hadoop][:hive][:version]
  home_dir      node[:hadoop][:hive][:home_dir]
  action        :install
  environment('JAVA_HOME' => node[:java][:java_home]) if node[:java][:java_home]
end

# When you install Hive via Cloudera's PPA the conf directory is
# /etc/hive/conf.  A release contains its *own* conf directory, which
# we will now symlink /etc/hive/conf to.

# Delete /etc/hive/conf if it already exists and is *not* a symlink.
directory node[:hadoop][:hive][:conf_dir] do
  action :delete
  only_if do !File.symlink?(node[:hadoop][:hive][:conf_dir]) end
end

directory node[:hadoop][:hive][:conf_base_dir] do
  recursive true
  action :create
  only_if do !File.exists?(node[:hadoop][:hive][:conf_base_dir]) end
end

link node[:hadoop][:hive][:conf_dir] do
  to          File.join(node[:hadoop][:hive][:home_dir],'conf')
  action      :create
end

template "/usr/bin/hive" do
  owner       "root"
  mode        "0755"
  source      "hive.erb"
end
