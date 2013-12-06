# -*- coding: utf-8 -*-

default[:hue][:version]               = "2.5.0"
default[:hue][:jobtracker_plugin_location] = "https://s3.amazonaws.com/artifacts.chimpy.us/jars/hue-plugins-2.5.0-SNAPSHOT.jar"

default[:hue][:run_state]             = :stop

default[:hue][:user]                  = 'hue'
default[:hue][:group]                 = 'hue'
default[:users ]['hue'][:uid]         = 309
default[:groups]['hue'][:gid]         = 309

default[:hue][:prefix_dir]            = '/usr/share'
default[:hue][:home_dir]              = '/usr/share/hue'
default[:hue][:conf_dir]              = '/etc/hue/conf'
default[:hue][:conf_base_dir]         = '/etc/hue'
default[:hue][:pid_dir]               = '/var/run/hue'

default[:hue][:port]                  = 9000
default[:hue][:time_zone]             = 'UTC'

default[:hue][:ssl][:key]             = nil
default[:hue][:ssl][:certificate]     = nil

default[:hue][:mysql][:host]          = ipaddress
default[:hue][:mysql][:port]          = 3306
default[:hue][:mysql][:username]      = 'hue'
default[:hue][:mysql][:password]      = nil
default[:hue][:mysql][:root_username] = 'root'
default[:hue][:mysql][:root_password] = nil
default[:hue][:mysql][:database]      = 'hue'

default[:hue][:beeswax][:fqdn]        = nil
default[:hue][:beeswax][:port]        = 8002
default[:hue][:beeswax][:meta_port]   = 8003
default[:hue][:beeswax][:heap_size]   = 2048

default[:hue][:smtp][:host]           = nil
default[:hue][:smtp][:port]           = nil
default[:hue][:smtp][:tls]            = nil
default[:hue][:smtp][:user]           = nil
default[:hue][:smtp][:password]       = nil
default[:hue][:smtp][:from]           = nil

default[:hadoop][:namenode][:webhdfs] = 'true'


