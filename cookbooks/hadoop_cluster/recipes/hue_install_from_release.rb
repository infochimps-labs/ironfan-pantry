include_recipe 'install_from'

daemon_user 'hue'

%w[ libxml2-dev libxslt-dev libsasl2-dev libsasl2-modules-gssapi-mit libmysqlclient-dev
    python-dev python-setuptools python-simplejson libsqlite3-dev ant ].each do |name|
  package name
end

install_from_release('hue') do
  release_url node[:hadoop][:hue][:release_url]
  version     node[:hadoop][:hue][:version]
  home_dir    node[:hadoop][:hue][:home_dir]
  action      :install_with_make
  environment({"PREFIX" => node[:hadoop][:hue][:home_dir]})
end

# When you install Hue via Cloudera's PPA the conf directory is
# /etc/hue/conf.  A release contains its *own* conf directory, which
# we will now symlink /etc/hue/conf to.

# Delete /etc/hue/conf if it already exists and is *not* a symlink.

# Delete /etc/hive/conf if it already exists and is *not* a symlink.
directory node[:hadoop][:hue][:conf_dir] do
  action :delete
  only_if do !File.symlink?(node[:hadoop][:hue][:conf_dir]) end
end

directory node[:hadoop][:hue][:conf_base_dir] do
  recursive true
  action :create
  only_if do !File.exists?(node[:hadoop][:hue][:conf_base_dir]) end
end

link node[:hadoop][:hue][:conf_dir] do
  to          File.join(node[:hadoop][:hue][:home_dir],'desktop/conf')
  action      :create
end

file File.join(node[:hadoop][:hue][:home_dir], 'apps/shell/src/shell/build/setuid') do
  mode  '4750'
  owner 'root'
  group node[:hadoop][:hue][:group]
end
