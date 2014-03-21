include_recipe("vayacondios_old::default")

daemon_user "vayacondios_old.server"

standard_dirs "vayacondios_old.server" do
  # do *not* include home_dir as it is actually a symlink that will
  # be created by the install_from_git recipe below
  directories :deploy_root, :log_dir, :conf_dir
end
include_recipe("vayacondios_old::install_from_git")

mongo = discover(:mongodb, :server)
Chef::Log.warn("No MongoDB database is available to clean (didn't set and couldn't discover node[:vayacondios_old][:mongodb][:database])") unless node[:vayacondios_old][:mongodb][:database]

# FIXME -- for now we're hard-coding to delete all events on the
# 'infochimps' topic from the last hour.  This needs to be more
# generally configurable if it is included at all.
cron "Clean old vayacondios_old events" do
  minute  "*/10"
  path    "/bin:/usr/bin:/usr/local/bin:/usr/sbin:/usr/local/sbin"
  command "cd #{node[:vayacondios_old][:home_dir]} && bundle exec vcd-clean --host=#{mongo && mongo.private_ip} --port=#{mongo && mongo.ports[:http][:port]} --database=#{node[:vayacondios_old][:mongodb][:database]} --upto=#{node[:vayacondios_old][:cleaner][:max_age]} --matching='^infochimps\..*\.events$' >> #{node[:vayacondios_old][:log_dir]}/cleaner.log 2>&1"
end
