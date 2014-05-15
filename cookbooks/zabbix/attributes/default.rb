#
# Cookbook Name:: zabbix
# Attributes:: default

# Global
zabbix_home_dir = '/usr/local/share/zabbix'
default[:zabbix][:home_dir]    = zabbix_home_dir
default[:zabbix][:pid_dir]     = '/var/run/zabbix'
default[:zabbix][:conf_dir]    = '/etc/zabbix'
default[:zabbix][:release_url] = "http://artifacts.chimpy.us.s3.amazonaws.com/tarballs/zabbix-:version:.tar.gz"

default[:zabbix][:user]             = "zabbix"
default[:zabbix][:group]            = "zabbix"
default[:users ]['zabbix'][:uid]    = 447
default[:groups]['zabbix'][:gid]    = 447

# Server -- there are *many* configuration options for the Zabbix
# server.  Most are hard-coded but documented in the
# zabbix_server.conf template.  Few have access through node
# attributes here.
default[:zabbix][:server][:version]           = "2.0.4"
default[:zabbix][:server][:install_method]    = "source"
default[:zabbix][:server][:configure_options] = [ "--with-libcurl","--with-net-snmp","--with-mysql", "--enable-java"]
default[:zabbix][:server][:log_dir]           = '/var/log/zabbix_server'
default[:zabbix][:server][:port]              = 10051

default[:zabbix][:server][:pollers]             = 5
default[:zabbix][:server][:unreachable_pollers] = 1
default[:zabbix][:server][:http_pollers]        = 1

default[:zabbix][:server][:trappers]    = 5
default[:zabbix][:server][:discoverers] = 5

default[:zabbix][:server][:ipmi][:pollers]  = 0
default[:zabbix][:server][:ipmi][:pingers]  = 1

default[:zabbix][:server][:snmp][:trapper]  = false

default[:zabbix][:server][:cache][:configuration]  = '64M'
default[:zabbix][:server][:cache][:history]        = '64M'
default[:zabbix][:server][:cache][:trend]          = '64M'
default[:zabbix][:server][:cache][:history_text]   = '64M'

default[:zabbix][:server][:memory][:shared_all]   = 536870912 # 512 MB total across caches
default[:zabbix][:server][:memory][:shared_max]   = 134217728 # up to 128 MB per cache


# Java Gateway
default[:zabbix][:java_gateway][:install] = true
default[:zabbix][:java_gateway][:port]    = 10052
default[:zabbix][:java_gateway][:log_dir] = '/var/log/zabbix_java'

# Database
default[:zabbix][:database][:host]            = "localhost"
default[:zabbix][:database][:port]            = 3306
default[:zabbix][:database][:root_user]       = "root"
default[:zabbix][:database][:root_password]   = nil
default[:zabbix][:database][:user]            = "zabbix"
default[:zabbix][:database][:password]        = nil
default[:zabbix][:database][:name]            = "zabbix"
default[:zabbix][:database][:install_method]  = 'mysql'

# Agent
default[:zabbix][:agent][:port]                   = 10050
default[:zabbix][:agent][:servers]                = []
default[:zabbix][:agent][:configure_options]      = ["--with-libcurl"]
default[:zabbix][:agent][:version]                = "2.0.4"
if platform_family?('rhel')
default[:zabbix][:agent][:install_method]         = "package"
else
default[:zabbix][:agent][:install_method]         = "prebuild"
end
default[:zabbix][:agent][:log_dir]                = '/var/log/zabbix_agent'
default[:zabbix][:agent][:create_host]            = true
default[:zabbix][:agent][:unmonitor_on_shutdown]  = false
default[:zabbix][:agent][:unsafe_user_parameters] = true
default[:zabbix][:agent][:enable_remote_commands] = true
default[:zabbix][:agent][:prebuild_url]           = "http://www.zabbix.com/downloads/:version:/zabbix_agents_:version:.:kernel:.:arch:.tar.gz"
default[:zabbix][:agent][:prebuild_kernel]        = "linux2_6"

# Web frontend
case platform
when "redhat", "centos"
default[:zabbix][:web][:user]           = "nginx"
default[:zabbix][:web][:group]          = "nginx"
when "ubuntu", "debian"
default[:zabbix][:web][:user]           = "www-data"
default[:zabbix][:web][:group]          = "www-data"
else
default[:zabbix][:web][:user]           = "www-data"
default[:zabbix][:web][:group]          = "www-data"
end

default[:zabbix][:web][:fqdn]           = ""
default[:zabbix][:web][:bind_ip]        = nil
default[:zabbix][:web][:port]           = 80
default[:zabbix][:web][:log_dir]        = '/var/log/zabbix_web'
default[:zabbix][:web][:tmp_dir]        = '/var/run/zabbix_web'
default[:zabbix][:web][:home_dir]       = File.join(zabbix_home_dir, 'frontends', 'php')
default[:zabbix][:web][:install_method] = 'nginx'
default[:zabbix][:web][:timezone]       = 'Europe/London' # UTC
default[:zabbix][:web][:user]           = 'www-data'      # should match user for nginx/apache
default[:zabbix][:web][:num_daemons]    = 1

# API
default[:zabbix][:api][:path]       = 'api_jsonrpc.php'
default[:zabbix][:api][:username]   = 'admin'
default[:zabbix][:api][:first_name] = 'Zabbix'
default[:zabbix][:api][:last_name]  = 'Administrator'
default[:zabbix][:api][:password]   = 'zabbix'
default[:zabbix][:api][:url]        = ''
default[:zabbix][:api][:autologin]  = '1'
default[:zabbix][:api][:autologout] = '0'
default[:zabbix][:api][:lang]       = 'en_GB'
default[:zabbix][:api][:refresh]    = '30'
default[:zabbix][:api][:type]       = '3' # 3 == super admin
default[:zabbix][:api][:theme]      = 'default'
default[:zabbix][:api][:rows]       = '200'

default[:zabbix][:api][:user_group] = 'chefs'
