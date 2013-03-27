
default[:silverware][:conf_dir] = '/etc/silverware'
default[:silverware][:log_dir]  = '/var/log/silverware'
default[:silverware][:home_dir] = '/etc/silverware'

default[:silverware][:user]     = 'root'

# Request user account properties here.
default[:users]['root'][:primary_user] = 'root'
default[:users]['root'][:primary_group] =
  case node[:platform]
  when "openbsd", "freebsd" then "wheel"
  when /mac_os_x/           then "wheel"
  else                           "root"
  end

default[:announces] ||= Mash.new

default[:discovers] ||= Mash.new        # FIXME: Deprecated, remove in 4.0
