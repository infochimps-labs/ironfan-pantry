# Install
default[:kafka][:package_name]                      = 'kafka'
default[:kafka][:version]                           = '0.7.1_incubating-1'
default[:kafka][:release_url]                       = "http://artifacts.chimpy.us.s3.amazonaws.com/tarballs/kafka-:version:-src.tgz"

default[:kafka][:user]                              = 'kafka'
default[:users ]['kafka'][:uid]                     = 452
default[:kafka][:group]                             = 'kafka'
default[:groups ]['kafka'][:gid]                    = 452

                                                                         # FIXME: don't set this to reuse the default attribute
default[:kafka][:install_dir]                       = "/usr/local/share/kafka-#{default[:kafka][:version]}"
default[:kafka][:home_dir]                          = '/usr/local/share/kafka'
default[:kafka][:conf_dir]                          = File.join(default[:kafka][:home_dir], 'config')
# Set via volume_dirs
default[:kafka][:journal_dir]                       = nil
default[:kafka][:log_dir]                           = '/var/log/kafka'
default[:kafka][:pid_dir]                           = '/var/run/kafka'

default[:kafka][:broker_id]                         = nil
default[:kafka][:broker_host_name]                  = nil
default[:kafka][:port]                              = 9092

# Keep this nil to default to the number of cores on the machine.
default[:kafka][:threads]                           = nil

default[:kafka][:log_flush_interval]                = 10000
default[:kafka][:log_flush_time_interval]           = 1000
default[:kafka][:log_flush_scheduler_time_interval] = 1000
default[:kafka][:log_retention_hours]               = 168
default[:kafka][:log_retention_size]                = nil # No limit by default

default[:kafka][:num_partitions]                    = 1
default[:kafka][:topic_partititon_count_map]        = nil

# Monitoring
default[:kafka][:jmx_port]                          = 9999

# Default location to write Kafka config to in Zookeeper
# Note: This must be a valid Zookeeper path! Also, you are responsible for
#       ensuring it exists before the server tries to connect. It will NOT
#       create it for you!
default[:kafka][:zookeeper_chroot]                  = '/'

#
# Machine tuning -- use the tuning cookbook to have this take effect
#
default[:tuning][:ulimit]['kafka']                  = { :nofile => { :both => 32768 } }

#
# Kafka Contrib attributes
#
default[:kafka][:contrib][:deploy][:root]           = '/usr/local/share/kafka-contrib'
default[:kafka][:contrib][:deploy][:repo]           = 'git@github.com:infochimps/kafka-contrib.git'
default[:kafka][:contrib][:deploy][:branch]         = 'master'
default[:kafka][:contrib][:log_dir]                 = '/var/log/kafka-contrib'
default[:kafka][:contrib][:auth_port]               = 80
default[:kafka][:contrib][:app_port]                = 8080
default[:kafka][:contrib][:http_basic_auth]         = false

#
# Kafka Contrib default attributes
#
# default[:kafka][:contrib][:app][:options]           = {}
# default[:kafka][:contrib][:app][:daemons]           = 1
# default[:kafka][:contrib][:app][:group_id]          = 0
# default[:kafka][:contrib][:app][:topic]             = ''
# default[:kafka][:contrib][:app][:run_state]         = :nothing

# I'm doing this to avoid breaking stuff that's working. Is this
# actually a sensible default? As an alternative to a global default,
# defaults could be set for each runner here.
default[:kafka][:contrib][:default_app_user] = 'root'

# This must be placed in the kafka install directory for the hadoop
# consumer to function correctly.
default[:kafka][:hadoop_jar] = 'https://s3.amazonaws.com/artifacts.chimpy.us/jars/hadoop-core-0.20.2-cdh3u2.jar'

default[:kafka][:server][:run_state] = :start

# FTP Loader
default[:kafka][:ftp_loader][:sites] = []

default[:kafka][:ftp_loader][:code_dir] = '/usr/local/share/kafka-contrib/current/'
default[:kafka][:ftp_loader][:conf_dir] = '/usr/local/share/kafka-contrib/shared/config/'
default[:kafka][:ftp_loader][:scripts_directory] = '/usr/local/share/kafka-contrib/current/scripts'
default[:kafka][:ftp_loader][:command] = "bundle exec ruby #{default[:kafka][:ftp_loader][:scripts_directory]}/ftp2s3.rb"
default[:kafka][:ftp_loader][:user] = 'root'



