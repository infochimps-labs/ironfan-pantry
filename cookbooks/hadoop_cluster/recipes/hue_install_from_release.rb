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

remote_file "/usr/local/src/hue-#{node[:hue][:version]}.tar.gz" do
  source node[:hue][:release_url].gsub(':version:', node[:hue][:version])
  mode "0644"
end

execute "tar zxvf hue-#{node[:hue][:version]}.tar.gz" do
  cwd "/usr/local/src"
  creates "/usr/local/src/hue"
end

execute "PREFIX=#{File.basedir(node[:hadoop][:hue][:home_dir])}" do
  cwd '/usr/local/src/hue'
  creates node[:hadoop][:hue][:home_dir]
end

directory node[:hadoop][:hue][:conf_dir] do
  recursive true
  action :create
end
