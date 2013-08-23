include_recipe 'install_from'


#
# Install Hive from latest release
#
#   puts Hive tarball into /usr/local/src/pig-xxx
#   expands it into /usr/local/share/pig-xxx
#   and links that to /usr/local/share/pig
#

%w[ libxml2-dev libxslt-dev libsasl2-dev libsasl2-modules-gssapi-mit libmysqlclient-dev
    python-dev python-setuptools python-simplejson libsqlite3-dev ant ].each do |name|
  package name
end

install_from_release('hue') do
  release_url   node[:hue][:release_url]
  version       node[:hue][:version]
  home_dir      node[:hadoop][:hue][:home_dir]
  action        [:install]
  environment('JAVA_HOME' => node[:java][:java_home]) if node[:java][:java_home]
end

directory node[:hadoop][:hue][:conf_dir] do
  recursive true
  action :create
end
