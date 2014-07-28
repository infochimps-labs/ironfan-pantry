template node[:vsftpd][:conf_dir] do
  source "chroot_list.conf.erb"
  mode   '0644'
  notifies :restart, "service[vsftpd]", :delayed
end
