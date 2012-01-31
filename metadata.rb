maintainer       "Chris Howe - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "3.0.3"

description      "HBase: a massively-scalable high-throughput datastore based on the Hadoop HDFS"

depends          "java"
depends          "apt"
depends          "runit"
depends          "volumes"
depends          "metachef"
depends          "dashpot"
depends          "hadoop_cluster"
depends          "zookeeper"
depends          "ganglia"

recipe           "hbase::backup_tables",               "Cron job to backup tables to S3"
recipe           "hbase::default",                     "Base configuration for hbase"
recipe           "hbase::master",                      "HBase Master"
recipe           "hbase::regionserver",                "HBase Regionserver"
recipe           "hbase::stargate",                    "HBase Stargate: HTTP frontend to HBase"
recipe           "hbase::thrift",                      "HBase Thrift Listener"
recipe           "hbase::dashboard",                   "Simple dashboard for HBase config and state"
recipe           "hbase::config",                      "Finalizes the config, writes out the config files"

%w[ debian ubuntu ].each do |os|
  supports os
end

attribute "groups/hbase/gid",
  :display_name          => "",
  :description           => "",
  :default               => "304"

attribute "hbase/tmp_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/mnt/hbase/tmp"

attribute "hbase/home_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/usr/lib/hbase"

attribute "hbase/conf_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/etc/hbase/conf"

attribute "hbase/log_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/log/hbase"

attribute "hbase/pid_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/run/hbase"

attribute "hbase/weekly_backup_tables",
  :display_name          => "",
  :description           => "",
  :default               => ""

attribute "hbase/backup_location",
  :display_name          => "",
  :description           => "",
  :default               => "/mnt/hbase/bkup"

attribute "hbase/master/java_heap_size_max",
  :display_name          => "",
  :description           => "",
  :default               => "1000m"

attribute "hbase/master/java_heap_size_new",
  :display_name          => "",
  :description           => "",
  :default               => "256m"

attribute "hbase/master/gc_tuning_opts",
  :display_name          => "",
  :description           => "",
  :default               => "-XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:+AggressiveOpts"

attribute "hbase/master/gc_log_opts",
  :display_name          => "",
  :description           => "",
  :default               => "-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps"

attribute "hbase/master/run_state",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => "start"

attribute "hbase/master/port",
  :display_name          => "",
  :description           => "",
  :default               => "60000"

attribute "hbase/master/dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "60010"

attribute "hbase/master/jmx_dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "10101"

attribute "hbase/regionserver/java_heap_size_max",
  :display_name          => "",
  :description           => "",
  :default               => "2000m"

attribute "hbase/regionserver/java_heap_size_new",
  :display_name          => "",
  :description           => "",
  :default               => "256m"

attribute "hbase/regionserver/gc_tuning_opts",
  :display_name          => "",
  :description           => "",
  :default               => "-XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:+AggressiveOpts -XX:CMSInitiatingOccupancyFraction=88"

attribute "hbase/regionserver/gc_log_opts",
  :display_name          => "",
  :description           => "",
  :default               => "-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps"

attribute "hbase/regionserver/run_state",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => "start"

attribute "hbase/regionserver/port",
  :display_name          => "",
  :description           => "",
  :default               => "60020"

attribute "hbase/regionserver/dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "60030"

attribute "hbase/regionserver/jmx_dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "10102"

attribute "hbase/regionserver/lease_period",
  :display_name          => "",
  :description           => "",
  :default               => "60000"

attribute "hbase/regionserver/handler_count",
  :display_name          => "",
  :description           => "",
  :default               => "10"

attribute "hbase/regionserver/split_limit",
  :display_name          => "",
  :description           => "",
  :default               => "2147483647"

attribute "hbase/regionserver/msg_period",
  :display_name          => "",
  :description           => "",
  :default               => "3000"

attribute "hbase/regionserver/log_flush_period",
  :display_name          => "",
  :description           => "",
  :default               => "1000"

attribute "hbase/regionserver/logroll_period",
  :display_name          => "",
  :description           => "",
  :default               => "3600000"

attribute "hbase/regionserver/split_check_period",
  :display_name          => "",
  :description           => "",
  :default               => "20000"

attribute "hbase/regionserver/worker_period",
  :display_name          => "",
  :description           => "",
  :default               => "10000"

attribute "hbase/regionserver/balancer_period",
  :display_name          => "",
  :description           => "",
  :default               => "300000"

attribute "hbase/regionserver/balancer_slop",
  :display_name          => "",
  :description           => "",
  :default               => "0"

attribute "hbase/regionserver/max_filesize",
  :display_name          => "",
  :description           => "",
  :default               => "268435456"

attribute "hbase/regionserver/hfile_block_size",
  :display_name          => "",
  :description           => "",
  :default               => "65536"

attribute "hbase/regionserver/required_codecs",
  :display_name          => "",
  :description           => "",
  :default               => ""

attribute "hbase/regionserver/block_cache_size",
  :display_name          => "",
  :description           => "",
  :default               => "0.2"

attribute "hbase/regionserver/hash_type",
  :display_name          => "",
  :description           => "",
  :default               => "murmur"

attribute "hbase/stargate/run_state",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => "start"

attribute "hbase/stargate/port",
  :display_name          => "",
  :description           => "",
  :default               => "8080"

attribute "hbase/stargate/jmx_dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "10105"

attribute "hbase/stargate/readonly",
  :display_name          => "",
  :description           => "",
  :default               => ""

attribute "hbase/thrift/run_state",
  :display_name          => "",
  :description           => "",
  :default               => "start"

attribute "hbase/thrift/jmx_dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "10104"

attribute "hbase/zookeeper/jmx_dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "10103"

attribute "hbase/zookeeper/peer_port",
  :display_name          => "",
  :description           => "",
  :default               => "2888"

attribute "hbase/zookeeper/leader_port",
  :display_name          => "",
  :description           => "",
  :default               => "3888"

attribute "hbase/zookeeper/client_port",
  :display_name          => "",
  :description           => "",
  :default               => "2181"

attribute "hbase/zookeeper/session_timeout",
  :display_name          => "",
  :description           => "",
  :default               => "180000"

attribute "hbase/zookeeper/znode_parent",
  :display_name          => "",
  :description           => "",
  :default               => "/hbase"

attribute "hbase/zookeeper/znode_rootserver",
  :display_name          => "",
  :description           => "",
  :default               => "root-region-server"

attribute "hbase/zookeeper/max_client_connections",
  :display_name          => "",
  :description           => "",
  :default               => "2000"

attribute "hbase/client/write_buffer",
  :display_name          => "",
  :description           => "",
  :default               => "2097152"

attribute "hbase/client/pause_period_ms",
  :display_name          => "",
  :description           => "",
  :default               => "1000"

attribute "hbase/client/retry_count",
  :display_name          => "",
  :description           => "",
  :default               => "10"

attribute "hbase/client/scanner_prefetch_rows",
  :display_name          => "",
  :description           => "",
  :default               => "1"

attribute "hbase/client/max_keyvalue_size",
  :display_name          => "",
  :description           => "",
  :default               => "10485760"

attribute "hbase/memstore/flush_upper_heap_pct",
  :display_name          => "",
  :description           => "",
  :default               => "0.4"

attribute "hbase/memstore/flush_lower_heap_pct",
  :display_name          => "",
  :description           => "",
  :default               => "0.35"

attribute "hbase/memstore/flush_size_trigger",
  :display_name          => "",
  :description           => "",
  :default               => "67108864"

attribute "hbase/memstore/preflush_trigger",
  :display_name          => "",
  :description           => "",
  :default               => "5242880"

attribute "hbase/memstore/flush_stall_trigger",
  :display_name          => "",
  :description           => "",
  :default               => "8"

attribute "hbase/memstore/mslab_enabled",
  :display_name          => "",
  :description           => "",
  :default               => ""

attribute "hbase/compaction/files_trigger",
  :display_name          => "",
  :description           => "",
  :default               => "3"

attribute "hbase/compaction/pause_trigger",
  :display_name          => "",
  :description           => "",
  :default               => "7"

attribute "hbase/compaction/pause_time",
  :display_name          => "",
  :description           => "",
  :default               => "90000"

attribute "hbase/compaction/max_combine_files",
  :display_name          => "",
  :description           => "",
  :default               => "10"

attribute "hbase/compaction/period",
  :display_name          => "",
  :description           => "",
  :default               => "86400000"

attribute "users/hbase/uid",
  :display_name          => "",
  :description           => "",
  :default               => "304"

attribute "tuning/ulimit/hbase",
  :display_name          => "",
  :description           => "",
  :type                  => "hash",
  :default               => {:nofile=>{:both=>32768}, :nproc=>{:both=>50000}}
