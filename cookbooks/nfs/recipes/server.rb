#
# Cookbook Name::       nfs
# Description::         NFS server: exports directories via NFS; announces using silverware.
# Recipe::              server
# Author::              37signals
#
# Copyright 2011, 37signals
#
# (no license specified)
#

if platform_family? "rhel"
  service_names = ['rpcbind', 'nfs']
elsif platform_family? "debian"
  service_names = ['nfs-kernel-server']
  package        "nfs-kernel-server"
end

if node[:nfs][:exports] && (not node[:nfs][:exports].empty?)

  # Announce as an NFS server, and announce each share as a capability
  announce(:nfs, :server, :addr  => private_ip_of(node), :realm => node[:nfs][:exports].values.first[:realm])
  node[:nfs][:exports].each do |nfs_path, nfs_info|
    nfs_info = nfs_info.merge(:addr  => private_ip_of(node), :path  => nfs_path)
    announce(:nfs, nfs_info[:name], nfs_info)
  end

  announce(:nfs, :server, {
           :daemons => {
             :nfs => {
               # nfsd is a kernel thread not a process, ps will display as [nfsd],
               # this is okay for our purposes
               :name => '[nfsd]',
               :user => 'root'
             }
           }
         })

  service_names.each do |service_name|
    service service_name do
      action [ :enable, :start ]
      running true
      supports :status => true, :restart => true
    end
  end

  template "#{node[:nfs][:conf_dir]}/exports" do
    source      "exports.erb"
    owner       node[:users]['root'][:primary_user]
    group       node[:users]['root'][:primary_group]
    mode        "0644"
    service_names.each do |service_name|
      notifies    :restart, resources(:service => service_name) if service_name
    end
  end

else
  Chef::Log.warn "You included the NFS server recipe without defining nfs exports: set node[:nfs][:exports]."
end

#
# For problems starting NFS server on ubuntu maverick systems: read, understand
# and then run /tmp/fix_nfs_on_maverick_amis.sh
#
if (platform?('ubuntu')) && (node[:lsb][:release].to_f == 10.10)
  template "/tmp/fix_nfs_on_maverick_amis.sh" do
    source      "fix_nfs_on_maverick_amis.sh"
    owner       'root'
    group       'root'
    mode        "0700"
  end
  if (`service nfs-kernel-server status` =~ /not running/)
    Chef::Log.warn "\n\n****\nFor problems starting NFS server on ubuntu maverick systems: read, understand and then run /tmp/fix_nfs_on_maverick_amis.sh\n****\n"
  end
end
