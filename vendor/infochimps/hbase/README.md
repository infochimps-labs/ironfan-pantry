# hbase chef cookbook

HBase: a massively-scalable high-throughput datastore based on the Hadoop HDFS

## Overview

Installs/Configures HBase

## Attributes

* `[:groups][:hbase][:gid]`           -  (default: "304")
* `[:hbase][:tmp_dir]`                -  (default: "/mnt/hbase/tmp")
* `[:hbase][:home_dir]`               -  (default: "/usr/lib/hbase")
* `[:hbase][:conf_dir]`               -  (default: "/etc/hbase/conf")
* `[:hbase][:log_dir]`                -  (default: "/var/log/hbase")
* `[:hbase][:pid_dir]`                -  (default: "/var/run/hbase")
* `[:hbase][:weekly_backup_tables]`   - 
* `[:hbase][:backup_location]`        -  (default: "/mnt/hbase/bkup")
* `[:hbase][:master][:java_heap_size_max]` -  (default: "1000m")
* `[:hbase][:master][:java_heap_size_new]` -  (default: "256m")
* `[:hbase][:master][:gc_tuning_opts]` -  (default: "-XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:+AggressiveOpts")
* `[:hbase][:master][:gc_log_opts]`   -  (default: "-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps")
* `[:hbase][:master][:run_state]`     -  (default: "start")
* `[:hbase][:master][:port]`          -  (default: "60000")
* `[:hbase][:master][:dash_port]`     -  (default: "60010")
* `[:hbase][:master][:jmx_dash_port]` -  (default: "10101")
* `[:hbase][:regionserver][:java_heap_size_max]` -  (default: "2000m")
* `[:hbase][:regionserver][:java_heap_size_new]` -  (default: "256m")
* `[:hbase][:regionserver][:gc_tuning_opts]` -  (default: "-XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:+AggressiveOpts -XX:CMSInitiatingOccupancyFraction=88")
* `[:hbase][:regionserver][:gc_log_opts]` -  (default: "-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps")
* `[:hbase][:regionserver][:run_state]` -  (default: "start")
* `[:hbase][:regionserver][:port]`    -  (default: "60020")
* `[:hbase][:regionserver][:dash_port]` -  (default: "60030")
* `[:hbase][:regionserver][:jmx_dash_port]` -  (default: "10102")
* `[:hbase][:regionserver][:lease_period]` -  (default: "60000")
* `[:hbase][:regionserver][:handler_count]` -  (default: "10")
* `[:hbase][:regionserver][:split_limit]` -  (default: "2147483647")
* `[:hbase][:regionserver][:msg_period]` -  (default: "3000")
* `[:hbase][:regionserver][:log_flush_period]` -  (default: "1000")
* `[:hbase][:regionserver][:logroll_period]` -  (default: "3600000")
* `[:hbase][:regionserver][:split_check_period]` -  (default: "20000")
* `[:hbase][:regionserver][:worker_period]` -  (default: "10000")
* `[:hbase][:regionserver][:balancer_period]` -  (default: "300000")
* `[:hbase][:regionserver][:balancer_slop]` -  (default: "0")
* `[:hbase][:regionserver][:max_filesize]` -  (default: "268435456")
* `[:hbase][:regionserver][:hfile_block_size]` -  (default: "65536")
* `[:hbase][:regionserver][:required_codecs]` - 
* `[:hbase][:regionserver][:block_cache_size]` -  (default: "0.2")
* `[:hbase][:regionserver][:hash_type]` -  (default: "murmur")
* `[:hbase][:stargate][:run_state]`   -  (default: "start")
* `[:hbase][:stargate][:port]`        -  (default: "8080")
* `[:hbase][:stargate][:jmx_dash_port]` -  (default: "10105")
* `[:hbase][:stargate][:readonly]`    - 
* `[:hbase][:thrift][:run_state]`     -  (default: "start")
* `[:hbase][:thrift][:jmx_dash_port]` -  (default: "10104")
* `[:hbase][:zookeeper][:jmx_dash_port]` -  (default: "10103")
* `[:hbase][:zookeeper][:peer_port]`  -  (default: "2888")
* `[:hbase][:zookeeper][:leader_port]` -  (default: "3888")
* `[:hbase][:zookeeper][:client_port]` -  (default: "2181")
* `[:hbase][:zookeeper][:session_timeout]` -  (default: "180000")
* `[:hbase][:zookeeper][:znode_parent]` -  (default: "/hbase")
* `[:hbase][:zookeeper][:znode_rootserver]` -  (default: "root-region-server")
* `[:hbase][:zookeeper][:max_client_connections]` -  (default: "2000")
* `[:hbase][:client][:write_buffer]`  -  (default: "2097152")
* `[:hbase][:client][:pause_period_ms]` -  (default: "1000")
* `[:hbase][:client][:retry_count]`   -  (default: "10")
* `[:hbase][:client][:scanner_prefetch_rows]` -  (default: "1")
* `[:hbase][:client][:max_keyvalue_size]` -  (default: "10485760")
* `[:hbase][:memstore][:flush_upper_heap_pct]` -  (default: "0.4")
* `[:hbase][:memstore][:flush_lower_heap_pct]` -  (default: "0.35")
* `[:hbase][:memstore][:flush_size_trigger]` -  (default: "67108864")
* `[:hbase][:memstore][:preflush_trigger]` -  (default: "5242880")
* `[:hbase][:memstore][:flush_stall_trigger]` -  (default: "8")
* `[:hbase][:memstore][:mslab_enabled]` - 
* `[:hbase][:compaction][:files_trigger]` -  (default: "3")
* `[:hbase][:compaction][:pause_trigger]` -  (default: "7")
* `[:hbase][:compaction][:pause_time]` -  (default: "90000")
* `[:hbase][:compaction][:max_combine_files]` -  (default: "10")
* `[:hbase][:compaction][:period]`    -  (default: "86400000")
* `[:users][:hbase][:uid]`            -  (default: "304")
* `[:tuning][:ulimit][:hbase]`        - 

## Recipes 

* `backup_tables`            - Cron job to backup tables to S3
* `config`                   - Finalizes the config, writes out the config files
* `dashboard`                - Simple dashboard for HBase config and state
* `default`                  - Base configuration for hbase
* `master`                   - HBase Master
* `regionserver`             - HBase Regionserver
* `stargate`                 - HBase Stargate: HTTP frontend to HBase
* `thrift`                   - HBase Thrift Listener

## Integration

Supports platforms: debian and ubuntu

Cookbook dependencies:
* java
* apt
* runit
* volumes
* metachef
* dashpot
* hadoop_cluster
* zookeeper
* ganglia


## License and Author

Author::                Chris Howe - Infochimps, Inc (<coders@infochimps.com>)
Copyright::             2011, Chris Howe - Infochimps, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

> readme generated by [cluster_chef](http://github.com/infochimps/cluster_chef)'s cookbook_munger
