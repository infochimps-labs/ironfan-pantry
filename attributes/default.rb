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
default[:zabbix][:server][:dbhost]            = "localhost"
default[:zabbix][:server][:dbname]            = "zabbix"
default[:zabbix][:server][:dbuser]            = "zabbix"
default[:zabbix][:server][:dbpassword]        = nil
default[:zabbix][:server][:dbport]            = "3306"
default[:zabbix][:server][:install_method]    = "source"
default[:zabbix][:server][:configure_options] = [ "--prefix=#{zabbix_home_dir}","--with-libcurl","--with-net-snmp","--with-mysql " ]
default[:zabbix][:server][:log_dir]           = '/var/log/zabbix_server'

# Web frontend
default[:zabbix][:web][:install]   = false
default[:zabbix][:web][:fqdn]      = "zabbix.example.com"
default[:zabbix][:web][:bind_ip]   = '127.0.0.1'
default[:zabbix][:web][:port]      = 9101
default[:zabbix][:web][:log_dir]   = '/var/log/zabbix_web'
default[:zabbix][:web][:webserver] = 'apache'
default[:zabbix][:web][:timezone]  = 'America/Chicago'

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


