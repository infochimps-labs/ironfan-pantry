package "python-twisted"

install_from_release('whisper') do
  version       node[:graphite][:whisper][:version]
  release_url   node[:graphite][:whisper][:release_url]
  checksum      node[:graphite][:whisper][:release_url_checksum]
  prefix_root   node[:graphite][:prefix_dir]
  home_dir      node[:graphite][:home_dir]
  install_dir   ::File.join(prefix_root, "#{name}-#{version}")
  action        [:install_python]
  not_if{ File.exists?("/usr/local/lib/python2.7/dist-packages/whisper-#{node[:graphite][:whisper][:version]}.egg-info") }
end

install_from_release('carbon') do
  version       node[:graphite][:carbon][:version]
  release_url   node[:graphite][:carbon][:release_url]
  checksum      node[:graphite][:carbon][:release_url_checksum]
  prefix_root   node[:graphite][:prefix_dir]
  home_dir      node[:graphite][:home_dir]
  install_dir   ::File.join(prefix_root, "#{name}-#{version}")
  action        [:install_python]
  install_args  :python_install => " --prefix=#{home_dir} --install-lib=#{home_dir}/lib"
  not_if{ File.exists?(File.join(node[:graphite][:home_dir],'lib',"carbon-#{node[:graphite][:carbon][:version]}-py2.7.egg-info")) }
end

install_from_release('dashboard') do
  version       node[:graphite][:dashboard][:version]
  release_url   node[:graphite][:dashboard][:release_url]
  checksum      node[:graphite][:dashboard][:release_url_checksum]
  prefix_root   node[:graphite][:prefix_dir]
  home_dir      node[:graphite][:home_dir]
  install_dir   ::File.join(prefix_root, "#{name}-#{version}")
  install_args  :python_install => " --prefix=#{home_dir} --install-lib=#{home_dir}/webapp"
  not_if{ File.exists?("#{node[:graphite][:home_dir]}/webapp/graphite_web-#{node[:graphite][:dashboard][:version]}-py2.7.egg-info") }
  action        [:install_python]
end

bash "update twisted plugins" do
  code %q{echo -e 'from twisted.plugin import IPlugin, getPlugins ; print "Twisted plugin cache: ", [plugin.__module__ for plugin in list(getPlugins(IPlugin))]' | python }
  environment   'PYTHONPATH' => "#{node[:graphite][:home_dir]}/lib"
  action        :nothing
  subscribes    :run, resources(:install_from_release => 'carbon'), :delayed
end
