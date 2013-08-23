include_recipe 'install_from'


#
# Install Hive from latest release
#
#   puts Hive tarball into /usr/local/src/pig-xxx
#   expands it into /usr/local/share/pig-xxx
#   and links that to /usr/local/share/pig
#

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
