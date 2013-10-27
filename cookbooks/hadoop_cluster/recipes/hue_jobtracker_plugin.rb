
Chef::Log.info("Downloading plugin from #{node[:hadoop][:hue][:jobtracker_plugin_location]}")

remote_file File.join(node[:hadoop][:home_dir], 'lib', File.basename(node[:hadoop][:hue][:jobtracker_plugin_location])) do
  source node[:hadoop][:hue][:jobtracker_plugin_location]
  mode   '0644'
  action :create
end
