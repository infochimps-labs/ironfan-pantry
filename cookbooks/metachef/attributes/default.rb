
default[:metachef][:conf_dir] = '/etc/metachef'
default[:metachef][:log_dir]  = '/var/log/metachef'
default[:metachef][:home_dir] = '/etc/metachef'

default[:metachef][:user]     = 'root'

# Request user account properties here.
default[:users]['root'][:primary_group] =
  case node[:platform]
  when "openbsd", "freebsd" then "wheel"
  when /mac_os_x/           then "wheel"
  else                           "root"
  end

default[:announces] ||= Mash.new

default[:discovers] ||= Mash.new
