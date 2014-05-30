#
# Install
#
default[:storm][:version]                  = '0.9.0_wip21-1'
default[:storm][:release_url]              = 'https://s3.amazonaws.com/artifacts.chimpy.us/zips/storm-:version:.zip'
default[:storm][:jzmq][:version]           = '2.1.0-1.el6'
default[:storm][:jzmq][:release_url]       = 'https://github.com/zeromq/jzmq/archive/v2.1.0.tar.gz'

#
# Users
#
default[:storm][:user]                     = 'storm'
default[:users ]['storm'][:uid]            = 370
default[:groups]['storm'][:gid]            = 370

#
# Directories
#
default[:storm][:home_dir]                 = '/usr/local/share/storm'
default[:storm][:data_dir]                 = nil # This will be set by volume_dirs
default[:storm][:log_dir]                  = '/var/log/storm'
default[:storm][:log_path_master]          = ::File.join(default[:storm][:log_dir], 'nimbus.log')
default[:storm][:log_path_worker]          = ::File.join(default[:storm][:log_dir], 'supervisor.log')
default[:storm][:log_path_ui]              = ::File.join(default[:storm][:log_dir], 'ui.log')
# These values are read-only!
default[:storm][:conf_dir]                 = '/etc/storm'
default[:storm][:pid_dir]                  = '/var/run/storm'.freeze

#
# Services
#
default[:storm][:master][:run_state]       = :start
default[:storm][:worker][:run_state]       = :start
default[:storm][:ui    ][:run_state]       = :start

#
# Tunables
#
# The number of worker worker_jvms to spin up per supervisor node
# The number of cores on a machine is a good place to start
# Best practice (by Flip) : One worker per node
default[:storm][:worker][:processes ]      = node[:cpu][:total]
default[:storm][:worker][:start_port]      = 6700

default[:storm][:master][:file_limit]      = 0xffff
default[:storm][:worker][:file_limit]      = 0xffff

default[:storm][:worker_jvm][:Xmx]         = '768m'
default[:storm][:worker_jvm][:Xms]         = '768m'
default[:storm][:worker_jvm][:Xss]         = '256k'
default[:storm][:worker_jvm][:MaxPermSize] = '128m'
default[:storm][:worker_jvm][:PermSize]    = '96m'
default[:storm][:worker_jvm][:NewSize]     = '350m'
default[:storm][:worker_jvm][:MaxNewSize]  = '350m'
