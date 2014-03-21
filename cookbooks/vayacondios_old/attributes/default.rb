default[:vayacondios_old][:git_url]          = "https://github.com/infochimps-labs/vayacondios.git"
default[:vayacondios_old][:git_version]      = 'leslie'
default[:vayacondios_old][:deploy_strategy]  = :deploy

default[:vayacondios_old][:organization] = nil

default[:vayacondios_old][:user]       = 'www-data'
default[:vayacondios_old][:group]      = 'webservers'

default[:vayacondios_old][:deploy_root]  = '/var/www/vayacondios_old'
default[:vayacondios_old][:home_dir]     = '/var/www/vayacondios_old/current'
default[:vayacondios_old][:conf_dir]     = '/var/www/vayacondios_old/shared/config'
default[:vayacondios_old][:log_dir]      = '/var/www/vayacondios_old/shared/log'
default[:vayacondios_old][:tmp_dir]      = '/var/www/vayacondios_old/shared/tmp'
default[:vayacondios_old][:pid_dir]      = '/var/www' # it's www-data

default[:vayacondios_old][:server][:port]        = 9000
default[:vayacondios_old][:server][:auth_port]   = 9001
default[:vayacondios_old][:server][:num_daemons] = 1
default[:vayacondios_old][:server][:verbose]     = false
default[:vayacondios_old][:server][:environment] = 'production'

default[:vayacondios_old][:mongodb][:database]    = nil # set in role
default[:vayacondios_old][:mongodb][:connections] = 20

default[:vayacondios_old][:cleaner][:clean]   = true
default[:vayacondios_old][:cleaner][:max_age] = "1h"
