require File.expand_path('simple_volume.rb', File.dirname(__FILE__))
module Metachef
  module_function

  # mountable volume mapping for this node
  #
  # @example
  #   # all three listed volumes will be mounted.
  #   node[:volumes] = {
  #     :root     => {                         :mount_point => "/",     :scratch => true, },
  #     :scratch1 => { :device => "/dev/sdb",  :mount_point => "/mnt",  :scratch => true, },
  #     :scratch2 => { :device => "/dev/sdc",  :mount_point => "/mnt2", :scratch => true, },
  #     :hdfs1    => { :device => "/dev/sdj",  :mount_point => "/data/hdfs1", :persistent => true, :attachable => :ebs },
  #     :hdfs2    => { :device => "/dev/sdk",  :mount_point => "/data/hdfs2", :persistent => true, :attachable => :ebs },
  #     }
  def volumes(node)
    return {} unless node[:volumes]
    vols = Mash.new
    node[:volumes].each do |vol_name, vol_hsh|
      vols[vol_name] = Metachef::SimpleVolume.new(vol_name, node, vol_hsh.to_hash)
      vols[vol_name].fix_for_xen!
    end
    vols
  end

  def raid_groups(node)
    volumes(node).select{|vol_name, vol| vol['sub_volumes'] && (not vol['sub_volumes'].empty?) }
  end

  def sub_volumes(node, raid_group)
    volumes(node).select{|vol_name, vol| vol['in_raid'] == raid_group.name }
  end

  def mounted_volumes(node)
    volumes(node).select{|vol_name, vol| vol.mounted? }
  end

  #
  # Try each tag in order to find thus-tagged volumes.
  # The first set to have a match is returned.
  #
  def volumes_tagged(node, *tags)
    vols = volumes(node)
    tags.each do |tag|
      result = vols.select{|vol_name, vol| vol.tagged?(tag) }
      return result unless result.empty?
    end
    vols
  end

end

class Chef::Recipe              ; include Metachef ; end
class Chef::Resource::Directory ; include Metachef ; end
class Chef::Resource            ; include Metachef ; end
