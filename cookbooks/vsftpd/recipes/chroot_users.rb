template node[:vsftpd][:conf_dir], 'chroot_list.conf' do
  source "chroot_list.conf.erb"
  mode   '0644'
  notifies :restart, "service[vsftpd]", :delayed
end
