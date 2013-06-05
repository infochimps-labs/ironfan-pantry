default[:storm][:version]             = "0.8.1"
default[:storm][:release_url]         = "https://dl.dropbox.com/u/133901206/storm-:version:.zip"

# The number of worker JVMs to spin up per supervisor node
# The number of cores on a machine is a good place to start
default[:storm][:worker][:processes ] = node[:cpu][:total]
default[:storm][:worker][:start_port] = 6700

default[:storm][:user]                = "storm"
default[:users ]['storm'][:uid]       = 370
default[:groups]['storm'][:gid]       = 370

default[:storm][:master][:file_limit] = 0xffff
default[:storm][:worker][:file_limit] = 0xffff

default[:storm][:home_dir]            = "/usr/local/share/storm"
default[:storm][:data_dir]            = nil # This will be set by volume_dirs
default[:storm][:log_dir]             = "/var/log/storm"
# These values are read-only!
default[:storm][:conf_dir]            = "#{node[:storm][:home_dir]}/conf"
default[:storm][:pid_dir]             = '/var/run/storm'.freeze # No PID for java stuff I guess...

default[:storm][:master][:run_state]  = :start
default[:storm][:worker][:run_state]  = :start
default[:storm][:ui    ][:run_state]  = :start
