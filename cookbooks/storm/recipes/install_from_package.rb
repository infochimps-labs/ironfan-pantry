daemon_user 'storm'

package 'jzmq' do
  options '--force-yes' if node[:platform] == 'ubuntu' || node[:platform] == 'debian'
  version node[:storm][:jzmq][:version]
end

package 'storm' do
  options '--force-yes' if node[:platform] == 'ubuntu' || node[:platform] == 'debian'
  version node[:storm][:version]
end

# Ensure storm executable is on path
link '/usr/local/bin/storm' do
  to File.join(node[:storm][:home_dir], 'bin/storm')
end

# CentOS doesn't add local to system paths
link '/usr/bin/storm' do
  to File.join(node[:storm][:home_dir], 'bin/storm')
end

include_recipe 'storm::directories'
