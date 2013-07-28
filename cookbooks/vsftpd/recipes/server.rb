volume_dirs('vsftpd.home') do
  selects       :single
  mode          "0700"
end

daemon_user(:vsftpd) do
  home node[:vsftpd][:home_dir] # instead of pid_dir
end

standard_dirs('vsftpd', 'server') do
  directories :conf_dir, :home_dir, :log_dir
end

package "vsftpd"

service "vsftpd" do
  supports :status => true, :stop => true, :start => true, :restart => true
  action :enable
end

include_recipe "vsftpd::ssl"

template "/etc/vsftpd.conf" do
  mode '0644'
  notifies :restart, resources(:service => "vsftpd"), :delayed
end

if node['vsftpd']['chroot_local_user'] or node['vsftpd']['chroot_list_enable']
  include_recipe "vsftpd::chroot_users"
end

if node['vsftpd']['virtual_users_enable']
  include_recipe "vsftpd::virtual_users"
end

announce(:ftp, :server,
         daemons: { server: { name: 'vsftpd', user: 'root' } },
         logs:    { server: node[:vsftpd][:log_dir] },
         ports:   { server: 21  })
