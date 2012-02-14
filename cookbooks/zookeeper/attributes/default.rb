
default[:zookeeper][:cluster_name]           = node[:cluster_name]

#
# Locations
#

default[:zookeeper][:home_dir]               = '/usr/lib/zookeeper'
default[:zookeeper][:conf_dir]               = '/etc/zookeeper'
default[:zookeeper][:log_dir]                = '/var/log/zookeeper'
default[:zookeeper][:pid_dir]                = '/var/run/zookeeper'

# default[:zookeeper][:journal_dir]          = '/var/zookeeper/txlog'
# default[:zookeeper][:data_dir]             = '/var/zookeeper/data'

default[:zookeeper][:client_port]            = '2181'
default[:zookeeper][:jmx_dash_port]          = '2182'
default[:zookeeper][:leader_port]            = '2888'
default[:zookeeper][:election_port]          = '3888'

#
# User
#

default[:zookeeper][:user]                   = 'zookeeper'
default[:users ]['zookeeper' ][:uid]         = 305
default[:groups]['zookeeper' ][:gid]         = 305

#
# Install
#

default[:zookeeper][:exported_jars]            = [ ::File.join(node[:zookeeper][:home_dir], "zookeeper.jar"), ]

#
# Services
#

default[:zookeeper][:server][:run_state] = :stop

#
# Tunables
#

default[:zookeeper][:java_heap_size_max] = 1000

# the length of a single tick, which is the basic time unit used by ZooKeeper,
# as measured in milliseconds. It is used to regulate heartbeats, and
# timeouts. For example, the minimum session timeout will be two ticks.
default[:zookeeper][:tick_time] = 2000

# ZooKeeper logs transactions to a transaction log. After snapCount transactions
# are written to a log file a snapshot is started and a new transaction log file
# is created. The default snapCount is 100,000.
default[:zookeeper][:snapshot_trigger] = 100_000

# Limits the number of concurrent connections (at the socket level) that a
# single client, identified by IP address, may make to a single member of the
# ZooKeeper ensemble. This is used to prevent certain classes of DoS attacks,
# including file descriptor exhaustion. The zookeeper default is 60; this file
# bumps that to 300, but you will want to turn this up even more on a production
# machine. Setting this to 0 entirely removes the limit on concurrent
# connections.
default[:zookeeper][:max_client_connections] = 300

# Time, in ticks, to allow followers to connect and sync to a leader. Increase
# if the amount of data managed by ZooKeeper is large
default[:zookeeper][:initial_timeout_ticks] = 10

# Time, in ticks, to allow followers to sync with ZooKeeper. If followers fall
# too far behind a leader, they will be dropped.
default[:zookeeper][:sync_timeout_ticks] = 5

# Should the leader accepts client connections? default "yes".  The leader
# machine coordinates updates. For higher update throughput at thes slight
# expense of read throughput the leader can be configured to not accept clients
# and focus on coordination. The default to this option is yes, which means that
# a leader will accept client connections. Turning on leader selection is highly
# recommended when you have more than three ZooKeeper servers in an ensemble.
#
# "auto" means "true if there are 4 or more zookeepers, false otherwise"
#
default[:zookeeper][:leader_is_also_server]  = 'auto'
