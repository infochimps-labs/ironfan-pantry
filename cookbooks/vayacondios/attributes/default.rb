default[:vayacondios][:user]  = 'www-data'
default[:vayacondios][:group] = 'webservers'
default[:vayacondios][:auth_port] = 9001

default[:vayacondios][:environment]     = 'production'
default[:vayacondios][:deploy_strategy] = :deploy
default[:vayacondios][:git_url]         = "https://github.com/infochimps-labs/vayacondios.git"
default[:vayacondios][:deploy_version]  = 'production'

default[:vayacondios][:deploy_root]  = '/var/www/vayacondios'
default[:vayacondios][:home_dir]     = '/var/www/vayacondios/current'
default[:vayacondios][:conf_dir]     = '/var/www/vayacondios/shared/config'
default[:vayacondios][:log_dir]      = '/var/www/vayacondios/shared/log'
default[:vayacondios][:pid_dir]      = '/var/www'

default[:vayacondios][:goliath][:port]     = 9000
default[:vayacondios][:mongodb][:database] = "dashpot_production"

default[:vayacondios][:legacy_mode] = false
