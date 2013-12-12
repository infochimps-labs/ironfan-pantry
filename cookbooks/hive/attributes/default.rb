
default[:hive][:version]                    = "0.10.0"

default[:hive][:home_dir]                   = '/usr/lib/hive'
default[:hive][:conf_dir]                   = '/etc/hive/conf'
default[:hive][:conf_base_dir]              = '/etc/hive'
default[:hive][:pid_dir]                    = '/var/run/hive'
default[:hive][:server][:log_dir]           = nil # set by volumes
default[:hive][:metastore][:log_dir]        = nil # set by volumes


default[:hive][:metastore][:run_state]      = :stop
default[:hive][:server][:run_state]         = :stop

default[:hive][:user]                       = 'hive'
default[:users ]['hive'][:uid]              = 310
default[:groups]['hive'][:gid]              = 310

default[:hive][:mysql][:host]               = ipaddress
default[:hive][:mysql][:port]               = 3306
default[:hive][:mysql][:root_username]      = 'root'
default[:hive][:mysql][:root_password]      = nil
default[:hive][:mysql][:username]           = 'hiveuser'
default[:hive][:mysql][:password]           = nil
default[:hive][:mysql][:database]           = 'metastore'

default[:hive][:mysql][:upgrade_script]     = 'scripts/metastore/upgrade/mysql/hive-schema-:version:.mysql.sql'
default[:hive][:mysql][:connector_jar]      = 'mysql-connector-java-5.1.22-bin.jar'
default[:hive][:mysql][:connector_location] = 'https://s3.amazonaws.com/artifacts.chimpy.us/jars/mysql-connector-java-5.1.22-bin.jar'

default[:hive][:input_format]               = 'org.apache.hadoop.hive.ql.io.HiveInputFormat'

default[:hive][:max_created_files]          = 100_000

default[:hive][:stats_autogather]           = false
