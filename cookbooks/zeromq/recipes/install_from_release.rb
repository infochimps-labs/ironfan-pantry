include_recipe 'install_from'

install_from_release('zeromq') do
  release_url   node[:zeromq][:release_url]
  version       node[:zeromq][:version]
  action        [:configure_with_autoconf, :install_with_make]
end
