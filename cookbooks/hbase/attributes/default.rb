#
# See also hbase/attributes/tunables.rb
#

#
# Locations
#

default[:hbase][:home_dir]                     = '/usr/lib/hbase'
default[:hbase][:conf_dir]                     = '/etc/hbase/conf'
default[:hbase][:pid_dir]                      = '/var/run/hbase'

default[:hbase][:log_dir]                      = '/var/log/hbase'
default[:hbase][:tmp_dir]                      = '/mnt/hbase/tmp'

default[:hbase][:master      ][:port]          = 60000
default[:hbase][:regionserver][:port]          = 60020
default[:hbase][:stargate    ][:port]          = 8080

default[:hbase][:master      ][:dash_port]     = 60010
default[:hbase][:regionserver][:dash_port]     = 60030

default[:hbase][:master      ][:jmx_dash_port] = 10101
default[:hbase][:regionserver][:jmx_dash_port] = 10102
default[:hbase][:zookeeper   ][:jmx_dash_port] = 10103
default[:hbase][:thrift      ][:jmx_dash_port] = 10104
default[:hbase][:stargate    ][:jmx_dash_port] = 10105

default[:hbase][:zookeeper   ][:peer_port]     = 2888
default[:hbase][:zookeeper   ][:leader_port]   = 3888
default[:hbase][:zookeeper   ][:client_port]   = 2181

# default[:hbase][:regionserver][:dash_addr]   = 0.0.0.0 # hbase.regionserver.info.bindAddress   (default 0.0.0.0) -- The address for the HBase RegionServer web UI
# default[:hbase][:zookeeper   ][:addr]        = default # hbase.zookeeper.dns.interface (default default) -- The name of the Network Interface from which a ZooKeeper server should report its IP address.
# default[:hbase][:regionserver][:addr]        = default # hbase.regionserver.dns.interface (default default) -- The name of the Network Interface from which a region server should report its IP address.
# default[:hbase][:master      ][:addr]        = default # hbase.master.dns.interface (default default) -- The name of the Network Interface from which a master should report its IP address.
# default[:hbase][:nameserver]                 = default # hbase.*.dns.nameserver (default default) -- The host name or IP address of the name server (DNS) which an hbase component should use to determine the host name used by the master for communication and display purposes.

# these are set by the recipes
node[:hbase][:exported_jars]   ||= []
node[:hbase][:exported_confs]  ||= []

#
# Users
#

# hbase user
node[:hbase][:user] = 'hbase'
default[:users ]['hbase'     ][:uid]    = 304
default[:groups]['hbase'     ][:gid]    = 304

#
# Run state of daemons
#

node[:hbase][:services] = [ :master, :regionserver, :stargate, :thrift ]

default[:hbase][:master      ][:run_state] = :start
default[:hbase][:regionserver][:run_state] = :start
default[:hbase][:thrift      ][:run_state] = :start
default[:hbase][:stargate    ][:run_state] = :start

#
# HBase Backup
#

default[:hbase][:backup_location]            = '/mnt/hbase/bkup'
default[:hbase][:weekly_backup_tables]       = []

#
# Stargate
#

# hbase.rest.readonly (default false) -- Defines the mode the REST server will be started
#   in. Possible values are: false: All HTTP methods are permitted - GET/PUT/POST/DELETE.
#   true: Only the GET method is permitted.
#
default[:hbase][:stargate][:readonly]                      = false              ## false
