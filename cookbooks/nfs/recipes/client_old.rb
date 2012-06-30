#
# Cookbook Name::       nfs
# Description::         NFS client: uses silverware to discover its server, and mounts the corresponding NFS directory
# Recipe::              client
# Author::              37signals
#
# Copyright 2011, 37signals
#
# (no license specified)
#

include_recipe 'nfs::default'

service('rpcbind').run_action(:start) if platform?(:centos)

bash "modprobe nfs" do
  user          'root'
  code          "modprobe nfs"
  not_if("cat /proc/filesystems | grep -q nfs")
end.run_action(:run)

nfs_server = discover(:nfs, :server)

if nfs_server.nil?
  Chef::Log.error("***************")
  Chef::Log.error("Can't find the NFS server: check that chef ran successfully on that machine. You may need to restart it after initial install.")
  Chef::Log.error("***************")
else
  begin
    require 'pry'
    binding.pry

    nfs_server_ip = nfs_server.info[:addr] || nfs_server.private_ip

    if node[:nfs] && node[:nfs][:mounts]
      node[:nfs][:mounts].each do |target, config|
        r = mount(target) do
          fstype      "nfs"
          options     %w(rw,soft,intr,nfsvers=3)
          device      (config[:device] || "#{nfs_server_ip}:#{config[:remote_path]}")
          dump        0
          pass        0
          action      :nothing
        end
        r.run_action(:mount) # do this immediately
      end
    else
      Chef::Log.warn "You included the NFS client recipe without defining nfs mounts."
    end
  rescue StandardError => err
    Chef::Log.warn "Problem setting up NFS:"
    Chef::Log.warn err
  end

end
