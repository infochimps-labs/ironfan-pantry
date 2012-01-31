maintainer       "Chris Howe - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "3.0.3"

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
  :description           => "",
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
  :description           => "",
  :default               => "2000"

attribute "zookeeper/snapshot_trigger",
  :display_name          => "",
  :description           => "",
  :default               => "100000"

attribute "zookeeper/initial_timeout_ticks",
  :display_name          => "",
  :description           => "",
  :default               => "10"

attribute "zookeeper/sync_timeout_ticks",
  :display_name          => "",
  :description           => "",
  :default               => "5"

attribute "zookeeper/leader_is_also_server",
  :display_name          => "",
  :description           => "",
  :default               => "auto"

attribute "zookeeper/server/run_state",
  :display_name          => "",
  :description           => "",
  :default               => "stop"

attribute "users/zookeeper/uid",
  :display_name          => "",
  :description           => "",
  :default               => "305"
