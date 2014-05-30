include_recipe 'install_from'

# JZMQ

install_from_release(:jzmq) do
  release_url   "https://github.com/nathanmarz/jzmq/tarball/master/nathanmarz-jzmq-master.tar.gz"
  home_dir      "/usr/local/share/jzmq"
  version       "2.1.0"
  autoconf_opts [ "&& sed -i 's/classdist_noinst.stamp/classnoinst.stamp/g' src/Makefile" ]
  action        [ :configure_with_autogen, :install_with_make ]
  environment('JAVA_HOME' => node[:java][:java_home]) if node[:java][:java_home]
end

# STORM

daemon_user 'storm'

install_from_release(:storm) do
  release_url   node[:storm][:release_url]
  home_dir      node[:storm][:home_dir]
  version       node[:storm][:version]
  checksum      node[:storm][:checksum]
  action        :install
  has_binaries  ['bin/storm']
end

include_recipe 'storm::directories'
