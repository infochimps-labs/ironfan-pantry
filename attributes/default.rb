#
# Cookbook Name:: zabbix
# Attributes:: default

# Global
zabbix_home_dir             = '/opt/zabbix'
default[:zabbix][:home_dir] = zabbix_home_dir

# Agent
default[:zabbix][:agent][:servers]           = []
default[:zabbix][:agent][:configure_options] = ["--prefix=#{zabbix_home_dir}", "--with-libcurl"]
default[:zabbix][:agent][:branch]            = "ZABBIX%20Latest%20Stable"
default[:zabbix][:agent][:install]           = true
default[:zabbix][:agent][:version]           = "1.8.5"
default[:zabbix][:agent][:install_method]    = "prebuild"
default[:zabbix][:agent][:log_dir]           = '/var/log/zabbix_agent'

# Server
default[:zabbix][:server][:install]           = false
default[:zabbix][:server][:version]           = "1.8.8"
default[:zabbix][:server][:branch]            = "ZABBIX%20Latest%20Stable"
default[:zabbix][:server][:install_method]    = "source"
default[:zabbix][:server][:configure_options] = [ "--prefix=#{zabbix_home_dir}","--with-libcurl","--with-net-snmp","--with-mysql " ]
default[:zabbix][:server][:log_dir]           = '/var/log/zabbix_server'

# Database
default[:zabbix][:database][:host]            = "localhost"
default[:zabbix][:database][:port]            = "3306"
default[:zabbix][:database][:root_user]       = ""
default[:zabbix][:database][:root_password]   = nil
default[:zabbix][:database][:user]            = "zabbix"
default[:zabbix][:database][:password]        = nil
default[:zabbix][:database][:name]            = "zabbix"

# Web frontend
default[:zabbix][:web][:install]   = false
default[:zabbix][:web][:fqdn]      = "zabbix.example.com"
default[:zabbix][:web][:bind_ip]   = '127.0.0.1'
default[:zabbix][:web][:port]      = 9101
default[:zabbix][:web][:log_dir]   = '/var/log/zabbix_web'
default[:zabbix][:web][:webserver] = 'apache'
default[:zabbix][:web][:timezone]  = 'America/Chicago'

# API
default[:zabbix][:api][:path]     = 'api_jsonrpc.php'
default[:zabbix][:api][:username] = ''
default[:zabbix][:web][:password] = ''

# SMTP
default[:zabbix][:smtp][:from]     = 'fixme@example.com' 
default[:zabbix][:smtp][:server]   = 'smtp.example.com'
default[:zabbix][:smtp][:port]     = '25'
default[:zabbix][:smtp][:username] = ''
default[:zabbix][:smtp][:password] = ''

# SMS -- Twilio
default[:zabbix][:twilio][:id]    = ''
default[:zabbix][:twilio][:token] = ''
default[:zabbix][:twilio][:phone] = ''
