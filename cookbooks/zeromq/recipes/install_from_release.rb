include_recipe 'install_from'

package 'libuuid-devel' if platform?('redhat', 'centos')

install_from_release('zeromq') do
  release_url   node[:zeromq][:release_url]
  version       node[:zeromq][:version]
  action        [:configure_with_autoconf, :install_with_make]
end
