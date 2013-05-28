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

if node[:nfs] && node[:nfs][:mounts] && (not node[:nfs][:mounts].empty?)
  node[:nfs][:mounts].each do |target, config|
    begin
      nfs_name = config[:name] || 'server'
      nfs_server = discover(:nfs, nfs_name)
      if nfs_server.nil?
        Chef::Log.error("***************")
        Chef::Log.error("Can't find the NFS server for 'nfs-#{nfs_name}' (#{target})")
        Chef::Log.error("If it's a new server, check that chef ran successfully on that machine. Depending on your kernel, you may need to reboot it once after initial install for the NFS server to work.")
        Chef::Log.error("It might also be a discovery problem: check the 'nfs' setting in node[:discovers] --  '#{node[:discovers] && node[:discovers].to_hash.inspect}'")
        Chef::Log.error("***************")
        next
      end

      nfs_server_ip = nfs_server.info[:addr] || nfs_server.private_ip
      Chef::Log.debug("Processing mount of #{target} from #{nfs_server_ip} (#{nfs_server.info})")
      r = mount(target) do
        fstype      "nfs"
        options     %w(rw,soft,intr,nfsvers=3)
        device      (config[:device] || "#{nfs_server_ip}:#{config[:remote_path]}")
        dump        0
        pass        0
        action      :nothing
      end
      r.run_action(:mount) # do this immediately

    rescue StandardError => err
      Chef::Log.warn "Problem setting up NFS:"
      Chef::Log.warn err
    end
  end

else
  Chef::Log.warn "You included the NFS client recipe without defining nfs mounts: #{node[:nfs].to_hash}"
end
