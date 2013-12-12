package("hue")
package("hue-plugins")

# Chef::Log.info("Downloading plugin from #{node[:hue][:jobtracker_plugin_location]}")

# remote_file File.join(node[:home_dir], 'lib', File.basename(node[:hue][:jobtracker_plugin_location])) do
#   source node[:hue][:jobtracker_plugin_location]
#   mode   '0644'
#   action :create
# end
