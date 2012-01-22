module Metachef
  class SimpleVolume < Mash
    attr_reader :node

    # Accessor methods for the common keys
    # sample:
    #   def device() self['device'] ; end
    %w[ device mount_options mount_dump mount_fsck device_type mount_point tags name in_raid_group
        sub_volumes level chunk read_ahead
      ].each do |attr|
      define_method(attr){ self[attr] if not self[attr].to_s.empty? }
    end

    def initialize(name, node, *args, &block)
      super(*args, &block)
      @node = node
      self['name']          = name
      self['tags']        ||= {}
      self['device_type'] ||= 'device'
    end

    def inspect
      str = [super()[2..-2]]
      str << "ohai_fstype:#{current[:fstype]}"
      "<#{self.class} #{str.join(" ")} #{current} a?#{attached?} m?#{mounted?} f?#{formattable?} r?#{resizable?}>"
    end

    # if device_type is :device, checks that the device is present.
    # if device_type is :label or :uuid, we have to assume it's ready.
    def attached?
      return true if (device_type.to_s != 'device')
      !!( device && File.exists?(device) )
    end

    # True if the volume is mounted
    def mounted?
      !!( attached? && mount_point && File.exists?(mount_point) && current[:mount] == mount_point )
    end

    # true if the volume is meant to be mounted
    def mountable?
      !!( mount_point && (self['mountable'].to_s != 'false') && (not in_raid?) )
    end

    # true if the volume is meant to be resized
    def resizable?
      !!( attached? && mount_point && (not in_raid?) &&
        (self['resizable'].to_s == 'true') && (self['resized'].to_s != 'true') )
    end

    def formattable?
      !!( self['fstype'] && self['device'] && (device_type == 'device') && (not in_raid?) &&
        (self['formattable'].to_s == 'true') && (self['formatted'].to_s != 'true') )
    end

    def ready_to_format?
      !!( formattable? && attached? && (not mounted?) && (`file -s #{device}`.chomp =~ /: data/) )
    end

    def in_raid?
      !! self['in_raid_group']
    end

    # true if tag is present and its value is truthy (non-nil non-false)
    def tagged?(tag)
      !! self.tag(tag)
    end

    def tag(tag)
      self['tags'][tag]
    end

    # user to set as volume owner -- default root
    def owner()  self['owner'] || 'root' ;    end
    # group to set as volume group -- default is platform-appropriate root-equivalent
    def group()  self['group'] || node[:users]['root'][:primary_group] ; end

    # Use `file -s` to identify volume type: ohai doesn't seem to want to do so.
    def fstype
      return self['fstype'] if has_key?('fstype')
      Chef::Log.info([
          self['fstype'], current[:fstype],
          File.exists?(device) && `file -s '#{device}'`.chomp,
          self,
        ].inspect)
      return current[:fstype] if current[:fstype]
      return unless File.exists?(device)
      dev_type_str = `file -s '#{device}'`.chomp
      case
      when dev_type_str =~ /SGI XFS/           then self['fstype'] = 'xfs'
      when dev_type_str =~ /Linux.*(ext[2-4])/ then self['fstype'] = $1
      else
        raise "Can't determine filesystem type of #{device} -- set it explicitly in node[:volumes]"
      end
      self['fstype']
    end

    # note that ohai repors :fs_type not :fstype
    def current
      return {} unless device && node[:filesystem] && node[:filesystem][ device ]
      curr = Mash.new(node[:filesystem][ device ].to_hash)
      curr['fstype'] ||= curr['fs_type']
      curr
    end

    # volume was resized, so mark it as no longer needing resize
    def resized!
      self[:resized] = true
      node[:volumes][name][:resized] = true
    end

    # volume was formatted, so mark it as no longer needing format
    def formatted!
      self[:formatted] = true
      node[:volumes][name][:formatted] = true
    end

    # On Xen virtualization systems (eg EC2), the volumes are *renamed* from
    # /dev/sdj to /dev/xvdj -- but the amazon API requires you refer to it as
    # /dev/sdj.
    #
    # If the virtualization is 'xen' **and** there are no /dev/sdXX devices
    # **and** there are /dev/xvdXX devices, we relabel all the /dev/sdXX device
    # points to be /dev/xvdXX.
    def fix_for_xen!
      return unless node[:virtualization] && (node[:virtualization][:system] == 'xen')
      return unless (Dir['/dev/sd*'].empty?) && (not Dir['/dev/xvd*'].empty?)
      return unless device
      self['device'].gsub!(%r{^/dev/sd}, '/dev/xvd')
    end
  end
end
