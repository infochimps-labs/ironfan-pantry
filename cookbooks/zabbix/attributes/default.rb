#
# Cookbook Name:: zabbix
# Attributes:: default

# Global
zabbix_home_dir                = '/opt/zabbix'
default[:zabbix][:home_dir]    = zabbix_home_dir

# Agent
default[:zabbix][:agent][:servers]                = []
default[:zabbix][:agent][:configure_options]      = ["--prefix=#{zabbix_home_dir}", "--with-libcurl"]
default[:zabbix][:agent][:branch]                 = "ZABBIX%20Latest%20Stable"
default[:zabbix][:agent][:version]                = "1.8.5"
default[:zabbix][:agent][:install_method]         = "prebuild"
default[:zabbix][:agent][:log_dir]                = '/var/log/zabbix_agent'
default[:zabbix][:agent][:create_host]            = true
default[:zabbix][:agent][:unmonitor_on_shutdown]  = false
default[:zabbix][:agent][:unsafe_user_parameters] = true

default[:zabbix][:user]  = "zabbix"
default[:users ]['zabbix'][:uid]    = 447
default[:groups]['zabbix'][:gid]    = 447

# Server
default[:zabbix][:server][:version]           = "1.8.8"
default[:zabbix][:server][:branch]            = "ZABBIX%20Latest%20Stable"
default[:zabbix][:server][:install_method]    = "source"
default[:zabbix][:server][:configure_options] = [ "--prefix=#{zabbix_home_dir}","--with-libcurl","--with-net-snmp","--with-mysql " ]
default[:zabbix][:server][:log_dir]           = '/var/log/zabbix_server'

# Database
default[:zabbix][:database][:host]            = "localhost"
default[:zabbix][:database][:port]            = "3306"
default[:zabbix][:database][:root_user]       = "root"
default[:zabbix][:database][:root_password]   = nil
default[:zabbix][:database][:user]            = "zabbix"
default[:zabbix][:database][:password]        = nil
default[:zabbix][:database][:name]            = "zabbix"
default[:zabbix][:database][:install_method]  = 'mysql'

# Web frontend
default[:zabbix][:web][:fqdn]           = ""
default[:zabbix][:web][:bind_ip]        = nil
default[:zabbix][:web][:port]           = 9101
default[:zabbix][:web][:log_dir]        = '/var/log/zabbix_web'
default[:zabbix][:web][:install_method] = 'apache'
default[:zabbix][:web][:timezone]       = 'Europe/London' # UTC

# API
default[:zabbix][:api][:path]       = 'api_jsonrpc.php'
default[:zabbix][:api][:username]   = 'chef'
default[:zabbix][:api][:password]   = 'fixme'
default[:zabbix][:api][:user_group] = 'chefs'
