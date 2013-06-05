default[:cube][:environment]     = 'production'
default[:cube][:deploy_strategy] = :deploy
default[:cube][:git_url]         = "https://github.com/infochimps-labs/cube.git"
default[:cube][:deploy_version]  = 'production'

default[:cube][:deploy_root] = '/var/www/cube'
default[:cube][:home_dir]    = '/var/www/cube/current'
default[:cube][:conf_dir]    = '/var/www/cube/shared/config'
default[:cube][:log_dir]     = '/var/www/cube/shared/log'
default[:cube][:tmp_dir]     = '/var/www/cube/shared/tmp'
default[:cube][:pid_dir]     = '/var/www/cube/shared/pids'

default[:cube][:collector][:http_port]    = 6000
default[:cube][:collector][:log_dir]      = '/var/www/cube/shared/log/collector'
default[:cube][:collector][:authenticate] = false
default[:cube][:collector][:instances]    = 1
default[:cube][:evaluator][:http_port]    = 6006
default[:cube][:evaluator][:log_dir]      = '/var/www/cube/shared/log/evaluator'
default[:cube][:evaluator][:authenticate] = true
default[:cube][:warmer][:log_dir]         = '/var/www/cube/shared/log/warmer'


default[:cube][:evaluator][:dns_name]   = nil    # set this to enable a public domain name
default[:cube][:evaluator][:dns_zone]   = nil    # set if the domain's zone is not its direct parent

default[:cube][:mongodb][:database] = "dashpot_production"

#
# User
#

default[:cube][:user]                   = 'cube'
default[:cube][:group]                  = 'webservers'
default[:users ]['cube'][:uid]          = 61323
default[:groups]['cube'][:gid]          = 61323
