maintainer        "Paper Cavalier"
maintainer_email  "code@papercavalier.com"
license           "Apache 2.0"
description       "Installs and configures MongoDB 1.8.0"
version           "0.2.6"

recipe "mongodb", "Default recipe simply includes the mongodb::source and mongodb::server recipes"
recipe "mongodb::apt", "Installs MongoDB from 10Gen's apt source and includes init.d script"
recipe "mongodb::backup", "Sets up MongoDB backup script, taken from http://github.com/micahwedemeyer/automongobackup"
recipe "mongodb::config_server", "Sets up config and initialization to run mongod as a config server for sharding"
recipe "mongodb::mongos", "Sets up config and initialization to run mongos, the MongoDB sharding router"
recipe "mongodb::server", "Set up config and initialization to run mongod as a database server"
recipe "mongodb::source", "Installs MongoDB from source and includes init.d script"

%w{ ubuntu debian }.each do |os|
  supports os
end

# Package info
attribute "mongodb/version",
  :display_name => "MongoDB source version",
  :description => "Which MongoDB version will be installed from source",
  :recipes => ["mongodb::source"],
  :default => "1.8.0"

attribute "mongodb/source",
  :display_name => "MongoDB source file",
  :description => "Downloaded location for MongoDB",
  :recipes => ["mongodb::source"],
  :calculated => true

attribute "mongodb/i686/checksum",
  :display_name => "MongoDB 32bit source file checksum",
  :description => "Will make sure the source file is the real deal",
  :recipes => ["mongodb::source"],
  :default => "b0b4d98968960cc90d2900ab0135bc24"

attribute "mongodb/x86_64/checksum",
  :display_name => "MongoDB 64bit source file checksum",
  :description => "Will make sure the source file is the real deal",
  :recipes => ["mongodb::source"],
  :default => "d764d869f2a3984251cfea5335cc6c53"


# Paths & port
attribute "mongodb/dir",
  :display_name => "MongoDB installation path",
  :description => "MongoDB will be installed here from source",
  :recipes => ["mongodb::source"],
  :default => "/opt/mongodb-1.8.0"

attribute "mongodb/datadir",
  :display_name => "MongoDB data store",
  :description => "All MongoDB data will be stored here",
  :default => "/var/db/mongodb"

attribute "mongodb/config",
  :display_name => "MongoDB config",
  :description => "Path to MongoDB config file",
  :default => "/etc/mongo.conf"

attribute "mongodb/logfile",
  :display_name => "MongoDB log file",
  :description => "MongoDB will log into this file",
  :default => "/var/log/mongodb.log"

attribute "mongodb/pidfile",
  :display_name => "MongoDB PID file",
  :description => "Path to MongoDB PID file",
  :default => "/var/run/mongodb.pid"

attribute "mongodb/port",
  :display_name => "MongoDB port",
  :description => "Accept connections on the specified port",
  :default => "27017"

attribute "mongodb/init_system",
  :display_name => "MongoDB init System",
  :description => "Init system to use for mongo servers",
  :choice => ["sysv", "upstart"],
  :default => "sysv"

attribute "mongodb/bind_ip",
  :display_name => "MongoDB bind IP",
  :description => "Accept connections on the interface with the given IP, or 0.0.0.0 for all",
  :default => "IP of eth0 if that interface exists, else 0.0.0.0"


# Logging, access & others
attribute "mongodb/log_cpu_io",
  :display_name => "MongoDB CPU & I/O logging",
  :description => "Enables periodic logging of CPU utilization and I/O wait",
  :default => "false"

attribute "mongodb/auth",
  :display_name => "MongoDB authentication",
  :description => "Turn on/off security",
  :default => "false"

attribute "mongodb/username",
  :display_name => "MongoDB useranme",
  :description => "If authentication is on, you might want to specify this for the db backups"

attribute "mongodb/password",
  :display_name => "MongoDB password",
  :description => "If authentication is on, you might want to specify this for the db backups"

attribute "mongodb/verbose",
  :display_name => "MongoDB verbose",
  :description => "Verbose logging output",
  :default => "false"

attribute "mongodb/objcheck",
  :display_name => "MongoDB objcheck",
  :description => "Inspect all client data for validity on receipt (useful for developing drivers)",
  :default => "false"

attribute "mongodb/quota",
  :display_name => "MongoDB quota",
  :description => "Enable db quota management",
  :default => "false"

attribute "mongodb/diaglog",
  :display_name => "MongoDB operations loggins",
  :description => "Set oplogging level where n is 0=off (default) 1=W 2=R 3=both 7=W+some reads",
  :default => "false"

attribute "mongodb/nocursors",
  :display_name => "MongoDB nocursors",
  :description => "Diagnostic/debugging option",
  :default => "false"

attribute "mongodb/nohints",
  :display_name => "MongoDB nohints",
  :description => "Ignore query hints",
  :default => "false"

attribute "mongodb/nohttp",
  :display_name => "MongoDB nohttp",
  :description => "Disable the HTTP interface (Defaults to localhost:27018)",
  :default => "false"

attribute "mongodb/noscripting",
  :display_name => "MongoDB noscripting",
  :description => "Turns off server-side scripting. This will result in greatly limited functionality.",
  :default => "false"

attribute "mongodb/notablescan",
  :display_name => "MongoDB notablescan",
  :description => "Turns off table scans. Any query that would do a table scan fails.",
  :default => "false"

attribute "mongodb/noprealloc",
  :display_name => "MongoDB noprealloc",
  :description => "Disable data file preallocation",
  :default => "false"

attribute "mongodb/nssize",
  :display_name => "MongoDB nssize",
  :description => "Specify .ns file size for new databases",
  :default => "false"


# Daemon options
attribute "mongodb/rest",
  :display_name => "MongoDB REST",
  :description => "Enables REST interface for extra info on Http Interface",
  :recipes => ["mongodb::server", "mongodb::config_server"],
  :default => "false"

attribute "mongodb/syncdelay",
  :display_name => "MongoDB syncdelay",
  :description => "Controls how often changes are flushed to disk",
  :recipes => ["mongodb::server", "mongodb::config_server"],
  :default => "60"


# Monitoring
attribute "mongodb/mms",
  :display_name => "MongoDB mms",
  :description => "Enable when you have a Mongo monitoring server",
  :default => "false"

attribute "mongodb/token",
  :display_name => "MongoDB mms-token",
  :description => "Accout token for Mongo monitoring server"

attribute "mongodb/name",
  :display_name => "MongoDB mms-name",
  :description => "Server name for Mongo monitoring server"

attribute "mongodb/interval",
  :display_name => "MongoDB mms-interval",
  :description => "Ping interval for Mongo monitoring server"


# Replication
attribute "mongodb/replication",
  :display_name => "MongoDB replication",
  :description => "Enable if you want to configure replication",
  :default => "false"

attribute "mongodb/slave",
  :display_name => "MongoDB replication slave",
  :description => "In replicated mongo databases, specify here whether this is a slave or master",
  :default => "false"

attribute "mongodb/slave_source",
  :display_name => "MongoDB replication slave source",
  :description => "Source for replication"

attribute "mongodb/slave_only",
  :display_name => "MongoDB replication slave only",
  :description => "Slave only: specify a single database to replicate"

attribute "mongodb/master",
  :display_name => "MongoDB replication master",
  :description => "In replicated mongo databases, specify here whether this is a slave or master",
  :default => "false"

attribute "mongodb/master_source",
  :display_name => "MongoDB replication master source",
  :description => "Source for replication"

attribute "mongodb/autoresync",
  :display_name => "MongoDB replication autoresync",
  :description => "Automatically resync if slave data is stale",
  :default => "false"

attribute "mongodb/oplogsize",
  :display_name => "MongoDB replication oplogsize",
  :description => "Custom size for replication operation log (in MB)",
  :default => "0"

attribute "mongodb/opidmem",
  :display_name => "MongoDB replication opidmem",
  :description => "Custom size limit for in-memory storage of op ids (in MB)",
  :default => "0"

attribute "mongodb/replica_set",
  :display_name => "MongoDB replica set", 
  :description => "Name of a replica set for server to join, passed directly to mongod with --replSet option",
  :recipes => ["mongodb::server"]


# Sharding
attribute "mongodb/shard_server",
  :display_name => "MongoDB shard server",
  :description => "Specify that server should participate in sharding, by passing --shardsvr to mongod startup",
  :recipes => ["mongodb::server"]


# Backups
attribute "mongodb/backup/host",
  :display_name => "MongoDB backup host",
  :description => "Host address of the MongoDB instance to back up",
  :default => "localhost"

attribute "mongodb/backup/backupdir",
  :display_name => "MongoDB backup directory",
  :description => "Backup directory location",
  :default => "/var/backups/mongodb"

attribute "mongodb/backup/day",
  :display_name => "MongoDB backup day",
  :description => "Which day do you want weekly backups? (1 to 7 where 1 is Monday)",
  :default => "6"

attribute "mongodb/backup/compression",
  :display_name => "MongoDB backup compression",
  :description => "Choose Compression type. (gzip or bzip2)",
  :default => "bzip2"

attribute "mongodb/backup/cleanup",
  :display_name => "MongoDB backup cleanup",
  :description => "Choose if the uncompressed folder should be deleted after compression has completed",
  :default => "yes"

attribute "mongodb/backup/latest",
  :display_name => "MongoDB backup latest",
  :description => "Additionally keep a copy of the most recent backup in a seperate directory",
  :default => "yes"

attribute "mongodb/backup/mailaddress",
  :display_name => "MongoDB backup mail",
  :description => "Email Address to send mail to after each backup",
  :default => "false"

attribute "mongodb/backup/mailcontent",
  :display_name => "MongoDB backup mailcontent",
  :description => %{
    What would you like to be mailed to you?
    - log   : send only log file
    - files : send log file and sql files as attachments (see docs)
    - stdout : will simply output the log to the screen if run manually
    - quiet : Only send logs if an error occurs
  }.strip,
  :default => "stdout"

attribute "mongodb/backup/maxemailsize",
  :display_name => "MongoDB backup max email size",
  :description => "Set the maximum allowed email size in k. (4000 = approx 5MB email)",
  :default => "4000"


# Config Server
attribute "mongodb/config_server/datadir",
  :display_name => "MongoDB config server data store",
  :description => "All MongoDB config server data will be stored here",
  :recipes => ["mongodb::config_server"],
  :default => "/var/db/mongodb-config"

attribute "mongodb/config_server/config",
  :display_name => "MongoDB config server configuration",
  :description => "Path to MongoDB config server config file",
  :recipes => ["mongodb::config_server"],
  :default => "/etc/mongodb-config.conf"

attribute "mongodb/config_server/logfile",
  :display_name => "MongoDB config server log file",
  :description => "MongoDB config server will log to this file",
  :recipes => ["mongodb::config_server"],
  :default => "/var/log/mongodb-config.log"

attribute "mongodb/config_server/pidfile",
  :display_name => "MongoDB config server PID file",
  :description => "Path to MongoDB config server PID file",
  :recipes => ["mongodb::config_server"],
  :default => "/var/run/mongodb-config.pid"

# FIXME: doesn't appear to be used
attribute "mongodb/config_server/host",
  :recipes => ["mongodb::config_server"],
  :default => "localhost"

attribute "mongodb/config_server/port",
  :display_name => "MongoDB config server port",
  :description => "Accept config server connections on the specified port",
  :recipes => ["mongodb::config_server"],
  :default => "27019"


# mongos
attribute "mongodb/mongos/config",
  :display_name => "MongoDB sharding router configuration",
  :description => "Path to MongoDB sharding router (mongos) config file",
  :recipes => ["mongodb::mongos"],
  :default => "/etc/mongos.conf"

attribute "mongodb/mongos/logfile",
  :display_name => "MongoDB sharding router log file",
  :description => "MongoDB sharding router (mongos) will log to this file",
  :recipes => ["mongodb::mongos"],
  :default => "/var/log/mongos.log"

attribute "mongodb/mongos/pidfile",
  :display_name => "MongoDB sharding router PID file",
  :description => "Path to MongoDB sharding router (mongos) PID file",
  :recipes => ["mongodb::mongos"],
  :default => "/var/run/mongos.pid"

# FIXME: doesn't appear to be used
attribute "mongodb/mongos/host",
  :recipes => ["mongodb::mongos"],
  :default => "localhost"

attribute "mongodb/mongos/port",
  :display_name => "MongoDB sharding router port",
  :description => "Accept sharding router (mongos) connections on the specified port. Clients will normally connect to this just as they would a database server.",
  :recipes => ["mongodb::mongos"],
  :default => "27017"

