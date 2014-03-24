default[:vayacondios][:git_url]               = "https://github.com/infochimps-labs/vayacondios.git"
default[:vayacondios][:git_version]           = 'master'
default[:vayacondios][:deploy_strategy]       = :deploy

default[:vayacondios][:organization]          = nil

default[:vayacondios][:user]                  = 'www-data'
default[:vayacondios][:group]                 = 'webservers'

default[:vayacondios][:deploy_root]           = '/var/www/vayacondios'
default[:vayacondios][:home_dir]              = '/var/www/vayacondios/current'
default[:vayacondios][:conf_dir]              = '/var/www/vayacondios/shared/config'
default[:vayacondios][:log_dir]               = nil # set by volume_dirs
default[:vayacondios][:tmp_dir]               = '/var/www/vayacondios/shared/tmp'
default[:vayacondios][:pid_dir]               = '/var/www' # it's www-data

default[:vayacondios][:server][:port]         = 9000
default[:vayacondios][:server][:auth_port]    = 9001
default[:vayacondios][:server][:num_daemons]  = 1
default[:vayacondios][:server][:verbose]      = false
default[:vayacondios][:server][:environment]  = 'production'

default[:vayacondios][:client][:conf_dir]     = '/etc/vayacondios'

default[:vayacondios][:mongodb][:database]    = nil # set in role
default[:vayacondios][:mongodb][:connections] = 20

default[:vayacondios][:cleaner][:clean]       = true
default[:vayacondios][:cleaner][:max_age]     = "1h"
