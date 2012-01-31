# cassandra chef cookbook

Cassandra: a massively scalable high-performance distributed storage system

## Overview

# Cassandra  Cluster

Cookbook based on Benjamin Black's (<b@b3k.us>) -- original at http://github.com/b/cookbooks/tree/cassandra/cassandra/

Modified to use `metachef` discovery and options preparation.

## Recipes 

* `authentication`           - Authentication
* `autoconf`                 - Automatically configure nodes from chef-server information.
* `bintools`                 - Bintools
* `client`                   - Client
* `default`                  - Base configuration for cassandra
* `ec2snitch`                - Automatically configure properties snitch for clusters on EC2.
* `install_from_git`         - Install From Git
* `install_from_package`     - Install From Package
* `install_from_release`     - Install From Release
* `iptables`                 - Automatically configure iptables rules for cassandra.
* `jna_support`              - Jna Support
* `mx4j`                     - Mx4j
* `ruby_client`              - support gems for cassandra (incl. fauna/cassandra and apache/avro)
* `server`                   - Server

## Integration

Supports platforms: debian and ubuntu

Cookbook dependencies:
* java
* apt
* runit
* thrift
* iptables
* volumes
* metachef
* install_from


## Attributes

* `[:cassandra][:cluster_name]`       - Cassandra cluster name (default: "cluster_name")
  - The name for the Cassandra cluster in which this node should participate.  The default is 'Test Cluster'.
* `[:cassandra][:home_dir]`           -  (default: "/usr/local/share/cassandra")
  - Directories, hosts and ports        # =
* `[:cassandra][:conf_dir]`           -  (default: "/etc/cassandra")
* `[:cassandra][:commitlog_dir]`      -  (default: "/mnt/cassandra/commitlog")
* `[:cassandra][:data_dirs]`          - 
* `[:cassandra][:saved_caches_dir]`   -  (default: "/var/lib/cassandra/saved_caches")
* `[:cassandra][:user]`               - cassandra (default: "cassandra")
  - The cassandra user
* `[:cassandra][:listen_addr]`        -  (default: "localhost")
* `[:cassandra][:seeds]`              - 
* `[:cassandra][:rpc_addr]`           -  (default: "localhost")
* `[:cassandra][:rpc_port]`           -  (default: "9160")
* `[:cassandra][:storage_port]`       -  (default: "7000")
* `[:cassandra][:jmx_dash_port]`      -  (default: "12345")
* `[:cassandra][:mx4j_port]`          -  (default: "8081")
* `[:cassandra][:mx4j_addr]`          -  (default: "127.0.0.1")
* `[:cassandra][:release_url]`        -  (default: ":apache_mirror:/cassandra/:version:/apache-cassandra-:version:-bin.tar.gz")
  - install_from_release: tarball url
* `[:cassandra][:git_repo]`           -  (default: "git://git.apache.org/cassandra.git")
  - Git repo location
* `[:cassandra][:git_revision]`       -  (default: "cdd239dcf82ab52cb840e070fc01135efb512799")
  - until ruby gem is updated, use cdd239dcf82ab52cb840e070fc01135efb512799
* `[:cassandra][:jna_deb_amd64_url]`  -  (default: "http://debian.riptano.com/maverick/pool/libjna-java_3.2.7-0~nmu.2_amd64.deb")
  - JNA deb location
* `[:cassandra][:auto_bootstrap]`     - Cassandra automatic boostrap boolean (default: "false")
  - Boolean indicating whether a node should automatically boostrap on startup.
* `[:cassandra][:keyspaces]`          - Cassandra keyspaces
  - Make a databag called 'cassandra', with an element 'clusters'. Within that, define a hash named for your cluster:
    
    - keys_cached:        specifies the number of keys per sstable whose locations we keep in memory in "mostly LRU" order.  (JUST the key locations, NOT any column values.) Specify a fraction (value less than 1) or an absolute number of keys to cache.  Defaults to 200000 keys.
    - rows_cached:        specifies the number of rows whose entire contents we cache in memory. Do not use this on ColumnFamilies with large rows, or ColumnFamilies with high write:read ratios. Specify a fraction (value less than 1) or an absolute number of rows to cache. Defaults to 0. (i.e. row caching is off by default)
    - comment:            used to attach additional human-readable information about the column family to its definition.
    - read_repair_chance: specifies the probability with which read repairs should be invoked on non-quorum reads.  must be between 0 and 1. defaults to 1.0 (always read repair).
    - preload_row_cache:  If true, will populate row cache on startup. Defaults to false.
    - gc_grace_seconds:   specifies the time to wait before garbage collecting tombstones (deletion markers). defaults to 864000 (10 days). See http://wiki.apache.org/cassandra/DistributedDeletes
    
* `[:cassandra][:authenticator]`      - Cassandra authenticator (default: "org.apache.cassandra.auth.AllowAllAuthenticator")
  - The IAuthenticator to be used for access control.
* `[:cassandra][:partitioner]`        -  (default: "org.apache.cassandra.dht.RandomPartitioner")
* `[:cassandra][:initial_token]`      - 
* `[:cassandra][:commitlog_rotation_threshold]` -  (default: "128")
* `[:cassandra][:thrift_framed_transport]` -  (default: "15")
* `[:cassandra][:disk_access_mode]`   -  (default: "auto")
* `[:cassandra][:sliced_buffer_size]` -  (default: "64")
* `[:cassandra][:column_index_size]`  -  (default: "64")
* `[:cassandra][:memtable_throughput]` -  (default: "64")
* `[:cassandra][:memtable_ops]`       -  (default: "0.3")
* `[:cassandra][:memtable_flush_after]` -  (default: "60")
* `[:cassandra][:concurrent_reads]`   -  (default: "8")
* `[:cassandra][:concurrent_writes]`  -  (default: "32")
* `[:cassandra][:commitlog_sync]`     -  (default: "periodic")
* `[:cassandra][:commitlog_sync_period]` -  (default: "10000")
* `[:cassandra][:authority]`          -  (default: "org.apache.cassandra.auth.AllowAllAuthority")
* `[:cassandra][:hinted_handoff_enabled]` -  (default: "true")
* `[:cassandra][:max_hint_window_in_ms]` -  (default: "3600000")
* `[:cassandra][:hinted_handoff_delay_ms]` -  (default: "50")
* `[:cassandra][:endpoint_snitch]`    -  (default: "org.apache.cassandra.locator.SimpleSnitch")
* `[:cassandra][:dynamic_snitch]`     -  (default: "true")
* `[:cassandra][:java_heap_size_min]` -  (default: "128M")
* `[:cassandra][:java_heap_size_max]` -  (default: "1650M")
* `[:cassandra][:java_heap_size_eden]` -  (default: "1500M")
* `[:cassandra][:memtable_flush_writers]` -  (default: "1")
* `[:cassandra][:thrift_max_message_length]` -  (default: "16")
* `[:cassandra][:incremental_backups]` - 
* `[:cassandra][:snapshot_before_compaction]` - 
* `[:cassandra][:in_memory_compaction_limit]` -  (default: "64")
* `[:cassandra][:compaction_preheat_key_cache]` -  (default: "true")
* `[:cassandra][:flush_largest_memtables_at]` -  (default: "0.75")
* `[:cassandra][:reduce_cache_sizes_at]` -  (default: "0.85")
* `[:cassandra][:reduce_cache_capacity_to]` -  (default: "0.6")
* `[:cassandra][:rpc_timeout_in_ms]`  -  (default: "10000")
* `[:cassandra][:rpc_keepalive]`      -  (default: "false")
* `[:cassandra][:phi_convict_threshold]` -  (default: "8")
* `[:cassandra][:request_scheduler]`  -  (default: "org.apache.cassandra.scheduler.NoScheduler")
* `[:cassandra][:throttle_limit]`     -  (default: "80")
* `[:cassandra][:request_scheduler_id]` -  (default: "keyspace")
* `[:cassandra][:log_dir]`            -  (default: "/var/log/cassandra")
* `[:cassandra][:lib_dir]`            -  (default: "/var/lib/cassandra")
* `[:cassandra][:pid_dir]`            -  (default: "/var/run/cassandra")
* `[:cassandra][:group]`              - nogroup (default: "nogroup")
  - The group that cassandra belongs to
* `[:cassandra][:version]`            -  (default: "0.7.10")
  - install_from_release
* `[:cassandra][:mx4j_version]`       -  (default: "3.0.2")
  - MX4J Version
* `[:cassandra][:mx4j_release_url]`   -  (default: "http://downloads.sourceforge.net/project/mx4j/MX4J%20Binary/x.x/mx4j-x.x.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fmx4j%2Ffiles%2F&ts=1303407638&use_mirror=iweb")
  - MX4J location (at least as of Version 3.0.2)
* `[:users][:cassandra][:uid]`        -  (default: "330")
* `[:users][:cassandra][:gid]`        -  (default: "330")
* `[:tuning][:ulimit][:cassandra]`    - 

## License and Author

Author::                Benjamin Black (<b@b3k.us>)
Copyright::             2011, Benjamin Black

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
