case node[:platform]
when "debian", "ubuntu"
  package "libpam-pwdfile"
when "centos", "redhat"
  package "passwd"
end

package "openssl"

template "/etc/pam.d/vsftpd" do
  source "vsftpd-pam.erb"
  mode   '0644'
  backup false
end

directory node[:vsftpd][:user_config_dir] do
  owner "root"
  group "root"
  mode 0755
end

(node[:vsftpd][:virtual_users] || []).each do |u|
  root_dir = File.join(node[:vsftpd][:home_dir], u[:root].gsub('/./','/'))
  directory root_dir  do
    owner     u[:local_user] || node[:vsftpd][:guest_username]
    group     u[:group]      || node[:vsftpd][:guest_group]
    recursive true
    mode      "0555"                 # for chroot to work user can't write to this directory
  end
  directory File.join(root_dir, 'incoming')  do
    owner     u[:local_user] || node[:vsftpd][:guest_username]
    group     u[:group]      || node[:vsftpd][:guest_group]
    recursive true
    mode      "0755"
  end
  vsftpd_user u[:name] do
    action     :add
    username   u[:name]
    password   u[:password]
    root       root_dir
    local_user u[:local_user] if u[:local_user]
  end
end
