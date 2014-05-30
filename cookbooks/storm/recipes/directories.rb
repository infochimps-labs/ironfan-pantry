standard_dirs 'storm' do
  directories [:log_dir, :conf_dir, :pid_dir, :data_dir]
end

# Remove the storm/logs dir and symlink it to our :log_dir
directory File.join(node[:storm][:home_dir], 'logs') do
  recursive   true
  action      :delete
  not_if      "test -L #{node[:storm][:log_dir]}"
end

# ln -s /var/log/storm /usr/local/share/storm/logs
link File.join(node[:storm][:home_dir], 'logs') do
  to          node[:storm][:log_dir]
  owner       node[:storm][:user]
end

# Remove the storm/conf dir and symlink it to our :conf_dir
directory File.join(node[:storm][:home_dir], 'conf') do
  recursive   true
  action      :delete
  not_if      "test -L #{node[:storm][:conf_dir]}"
end

# ln -s /var/log/storm /usr/local/share/storm/logs
link File.join(node[:storm][:home_dir], 'conf') do
  to          node[:storm][:conf_dir]
  owner       node[:storm][:user]
end
