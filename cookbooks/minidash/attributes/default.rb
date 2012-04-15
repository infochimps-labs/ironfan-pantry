
# hash, name => app dashboard url
# add yours using add_minidash_link
default[:minidash][:links]     ||= Mash.new

#
# Location
#

default[:minidash][:conf_dir] = '/etc/minidash'
default[:minidash][:log_dir]  = '/var/log/minidash'
default[:minidash][:home_dir] = '/var/lib/minidash'

#
# Dashboard service -- lightweight THTTPD daemon
#

default[:minidash][:port]        = 5678
default[:minidash][:run_state]   = :start

default[:minidash][:user]     = 'root'
