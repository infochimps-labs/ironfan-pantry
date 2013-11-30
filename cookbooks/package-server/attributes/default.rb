# User
default[:package_server][:user]             = 'www-data'
default[:package_server][:group]            = 'www-data'
default[:package_server][:pid_dir]          = '/var/www/pid'
default[:package_server][:log_dir]          = '/var/log/package_server'

# Private apt server
default[:package_server][:apt][:log_dir]    = '/var/www/apt/log'

# Private gem server
default[:package_server][:gem][:data_dir]   = '/data/gem'
default[:package_server][:gem][:home_dir]   = '/var/www/gem'
default[:package_server][:gem][:conf_dir]   = '/var/www/gem/config'
default[:package_server][:gem][:log_dir]    = '/var/www/gem/log'
default[:package_server][:gem][:tmp_dir]    = '/var/www/gem/tmp'

default[:package_server][:gem][:port]       = 7010
default[:package_server][:gem][:workers]    = 2
default[:package_server][:gem][:dns_prefix] = 'gem'

# Private git server
default[:package_server][:git][:log_dir]    = '/var/www/git/log'
