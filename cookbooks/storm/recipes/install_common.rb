standard_dirs 'storm' do
  directories [:log_dir, :conf_dir, :pid_dir, :data_dir]
end

# Remove the storm/logs dir and symlink it to our :log_dir
directory File.join(node[:storm][:home_dir], 'logs') do
  recursive true
  action :delete
end

# ln -s /var/log/storm /usr/local/share/storm/logs
link File.join(node[:storm][:home_dir], 'logs') do
  to node[:storm][:log_dir]
  owner node[:storm][:user]
end
