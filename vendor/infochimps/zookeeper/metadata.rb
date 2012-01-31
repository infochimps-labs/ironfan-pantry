maintainer       "Chris Howe - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "3.0.4"

description      "Zookeeper, a distributed high-availability consistent datastore"

depends          "java"
depends          "apt"
depends          "runit"
depends          "volumes"
depends          "metachef"
depends          "hadoop_cluster"

recipe           "zookeeper::client",                  "Installs Zookeeper client libraries"
recipe           "zookeeper::default",                 "Base configuration for zookeeper"
recipe           "zookeeper::server",                  "Installs Zookeeper server, sets up and starts service"
recipe           "zookeeper::config_files",            "Config files -- include this last after discovery"

%w[ debian ubuntu ].each do |os|
  supports os
end

attribute "groups/zookeeper/gid",
  :display_name          => "",
  :description           => "",
  :default               => "305"

attribute "zookeeper/data_dir",
  :display_name          => "",
  :description           => "[set by recipe]",
  :default               => "/var/zookeeper"

attribute "zookeeper/journal_dir",
  :display_name          => "",
  :description           => "[set by recipe]",
  :default               => "/var/zookeeper"

attribute "zookeeper/cluster_name",
  :display_name          => "",
  :description           => "",
  :default               => "cluster_name"

attribute "zookeeper/log_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/log/zookeeper"

attribute "zookeeper/max_client_connections",
  :display_name          => "",
  :description           => "Limits the number of concurrent connections (at the socket level) that a\nsingle client, identified by IP address, may make to a single member of the\nZooKeeper ensemble. This is used to prevent certain classes of DoS attacks,\nincluding file descriptor exhaustion. The zookeeper default is 60; this file\nbumps that to 300, but you will want to turn this up even more on a production\nmachine. Setting this to 0 entirely removes the limit on concurrent\nconnections.",
  :default               => "300"

attribute "zookeeper/home_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/usr/lib/zookeeper"

attribute "zookeeper/exported_jars",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => ["/usr/lib/zookeeper/zookeeper.jar"]

attribute "zookeeper/conf_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/etc/zookeeper"

attribute "zookeeper/user",
  :display_name          => "",
  :description           => "",
  :default               => "zookeeper"

attribute "zookeeper/pid_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/run/zookeeper"

attribute "zookeeper/client_port",
  :display_name          => "",
  :description           => "",
  :default               => "2181"

attribute "zookeeper/jmx_dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "2182"

attribute "zookeeper/leader_port",
  :display_name          => "",
  :description           => "",
  :default               => "2888"

attribute "zookeeper/election_port",
  :display_name          => "",
  :description           => "",
  :default               => "3888"

attribute "zookeeper/java_heap_size_max",
  :display_name          => "",
  :description           => "",
  :default               => "1000"

attribute "zookeeper/tick_time",
  :display_name          => "",
  :description           => "the length of a single tick, which is the basic time unit used by ZooKeeper,\nas measured in milliseconds. It is used to regulate heartbeats, and\ntimeouts. For example, the minimum session timeout will be two ticks.",
  :default               => "2000"

attribute "zookeeper/snapshot_trigger",
  :display_name          => "",
  :description           => "ZooKeeper logs transactions to a transaction log. After snapCount transactions\nare written to a log file a snapshot is started and a new transaction log file\nis created. The default snapCount is 100,000.",
  :default               => "100000"

attribute "zookeeper/initial_timeout_ticks",
  :display_name          => "",
  :description           => "Time, in ticks, to allow followers to connect and sync to a leader. Increase\nif the amount of data managed by ZooKeeper is large",
  :default               => "10"

attribute "zookeeper/sync_timeout_ticks",
  :display_name          => "",
  :description           => "Time, in ticks, to allow followers to sync with ZooKeeper. If followers fall\ntoo far behind a leader, they will be dropped.",
  :default               => "5"

attribute "zookeeper/leader_is_also_server",
  :display_name          => "",
  :description           => "Should the leader accepts client connections? default \"yes\".  The leader\nmachine coordinates updates. For higher update throughput at thes slight\nexpense of read throughput the leader can be configured to not accept clients\nand focus on coordination. The default to this option is yes, which means that\na leader will accept client connections. Turning on leader selection is highly\nrecommended when you have more than three ZooKeeper servers in an ensemble.\n\"auto\" means \"true if there are 4 or more zookeepers, false otherwise\"",
  :default               => "auto"

attribute "zookeeper/server/run_state",
  :display_name          => "",
  :description           => "",
  :default               => "stop"

attribute "users/zookeeper/uid",
  :display_name          => "",
  :description           => "",
  :default               => "305"
