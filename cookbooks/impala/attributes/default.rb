#
# Users
#
default[:impala][:user]                       = 'impala'
default[:users ]['impala'][:uid]              = 312
default[:groups]['impala'][:gid]              = 312

#
# Install
#
default[:impala][:version]                    = '1.1.1'
default[:impala][:release_url]                = 'https://github.com/cloudera/impala/arcimpala/impala-v:version:.tar.gz'

#
# Directories
#
default[:impala][:home_dir]                   = '/usr/lib/impala'
default[:impala][:conf_dir]                   = '/etc/impala/conf'
default[:impala][:conf_base_dir]              = '/etc/impala'
default[:impala][:pid_dir]                    = '/var/run/impala'

default[:impala][:log_dir]                    = nil # set by volumes
default[:impala][:server     ][:log_dir]      = nil # set by volumes
default[:impala][:catalog    ][:log_dir]      = nil # set by volumes
default[:impala][:state_store][:log_dir]      = nil # set by volumes

#
# Services
#
default[:impala][:server     ][:run_state]    = :stop
default[:impala][:catalog    ][:run_state]    = :stop
default[:impala][:state_store][:run_state]    = :stop
