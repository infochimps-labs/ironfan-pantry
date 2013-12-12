
default[:impala][:user]                       = 'impala'
default[:users ]['impala'][:uid]              = 311
default[:groups]['impala'][:gid]              = 311
default[:impala][:version]                    = "1.1.1"
default[:impala][:release_url]                = "https://github.com/cloudera/impala/arcimpala/impala-v:version:.tar.gz"

default[:impala][:home_dir]                   = '/usr/lib/impala'
default[:impala][:conf_dir]                   = '/etc/impala/conf'
default[:impala][:conf_base_dir]              = '/etc/impala'
default[:impala][:pid_dir]                    = '/var/run/impala'

default[:impala][:state_store][:log_dir]       = nil # set by volumes
default[:impala][:server][:log_dir]           = nil # set by volumes

default[:impala][:server][:run_state]         = :stop
default[:impala][:state_store][:run_state]    = :stop
