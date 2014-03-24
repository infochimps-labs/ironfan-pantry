include_recipe("vayacondios::default")

daemon_user "vayacondios.server"

standard_dirs "vayacondios.server" do
  # do *not* include home_dir as it is actually a symlink that will
  # be created by the install_from_git recipe below
  directories :deploy_root, :conf_dir
end
include_recipe("vayacondios::install_from_git")

mongo = discover(:mongodb, :server)
Chef::Log.warn("No MongoDB database is available to clean (didn't set and couldn't discover node[:vayacondios][:mongodb][:database])") unless node[:vayacondios][:mongodb][:database]

# FIXME -- for now we're hard-coding to delete all events on the
# 'infochimps' topic from the last hour.  This needs to be more
# generally configurable if it is included at all.
cron "Clean old Vayacondios events" do
  minute  "*/10"
  path    "/bin:/usr/bin:/usr/local/bin:/usr/sbin:/usr/local/sbin"
  command "cd #{node[:vayacondios][:home_dir]} && bundle exec vcd-clean --host=#{mongo && mongo.private_ip} --port=#{mongo && mongo.ports[:http][:port]} --database=#{node[:vayacondios][:mongodb][:database]} --upto=#{node[:vayacondios][:cleaner][:max_age]} --matching='^infochimps\..*\.events$' >> #{node[:vayacondios][:log_dir]}/cleaner.log 2>&1"
end
