default[:storm][:version]             = "0.9.0-wip21-ics"
default[:storm][:release_url]         = "https://s3.amazonaws.com/artifacts.chimpy.us/zips/storm-:version:.zip"

# The number of worker worker_jvms to spin up per supervisor node
# The number of cores on a machine is a good place to start
# Best practice (by Flip) : One worker per node
default[:storm][:worker][:processes ] = node[:cpu][:total]
default[:storm][:worker][:start_port] = 6700

default[:storm][:user]                = "storm"
default[:users ]['storm'][:uid]       = 370
default[:groups]['storm'][:gid]       = 370

default[:storm][:master][:file_limit] = 0xffff
default[:storm][:worker][:file_limit] = 0xffff

default[:storm][:home_dir]            = "/usr/local/share/storm"
default[:storm][:data_dir]            = nil # This will be set by volume_dirs
default[:storm][:log_dir]             = nil   # set by volume_dirs
default[:storm][:log_path_master]     = ::File.join(default[:storm][:log_dir],"nimbus.log")
default[:storm][:log_path_worker]     = ::File.join(default[:storm][:log_dir],"supervisor.log")
default[:storm][:log_path_ui]         = ::File.join(default[:storm][:log_dir],"ui.log")
# These values are read-only!
default[:storm][:conf_dir]            = "#{node[:storm][:home_dir]}/conf"
default[:storm][:pid_dir]             = '/var/run/storm'.freeze # No PID for java stuff I guess...

default[:storm][:master][:run_state]  = :start
default[:storm][:worker][:run_state]  = :start
default[:storm][:ui    ][:run_state]  = :start

#worker_jvm options - for c1.xlarge
default[:storm][:worker_jvm][:Xmx]   =  "768m"
default[:storm][:worker_jvm][:Xms]   =  "768m"
default[:storm][:worker_jvm][:Xss]   =  "256k"
default[:storm][:worker_jvm][:MaxPermSize]   =  "128m"
default[:storm][:worker_jvm][:PermSize]   =     "96m"
default[:storm][:worker_jvm][:NewSize]   =      "350m"
default[:storm][:worker_jvm][:MaxNewSize]   =   "350m"
