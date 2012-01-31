# hadoop_cluster chef cookbook

Hadoop: distributed massive-scale data processing framework. Store and analyze terabyte-scale datasets with ease

## Overview

The hadoop_cluster cookbook lets you spin up hadoop clusters of arbitrary size, makes it easy to configure and tune them, and opens up powerful new ways to reduce your compute bill. 

This cookbook installs Apache hadoop using the [Cloudera hadoop distribution (CDH)](http://archive.cloudera.com/docs/), and it plays well with the infochimps cookbooks for HBase, Flume, ElasticSearch, Zookeeper, Ganglia and Zabbix.

### Cluster instantiation

Instantiating a cluster from thin air requires
* start the master, with all the `:run_state`s set to 'stop'
* running `/etc/hadoop/conf/bootstrap_hadoop_namenode.sh`, which is now fairly robust and re-runnable. It should start the namenode on its own.
* set `run_state`s to 'start', run `knife cluster sync` and then `knife cluster kick` the master.
* launch the jobbtracker, workers, etc.

### Tunables

For more details on the so, so many config variables, see

* [Core Hadoop params](http://archive.cloudera.com/cdh/3/hadoop/hdfs-default.html) 
* [HDFS params](http://archive.cloudera.com/cdh/3/hadoop/hdfs-default.html) 
* [Map-Reduce params](http://archive.cloudera.com/cdh/3/hadoop/hdfs-default.html) 

### Advanced Cluster-Fu for the impatient cheapskate

#### Stop-start clusters

If you have a persistent HDFS, you can shut down the cluster with `knife cluster stop` at the end of your workday, and restart it in less time than it takes to get your morning coffee.  Typical time from typing "knife cluster launch science-worker" until the node reports in the jobtracker is <= 6 minutes on launch -- faster than that on start.

Stopped nodes don't cost you anything in compute, though you do continue to pay for the storage on their attached drives. See [the example science cluster](example/clusters/science.rb) for the setup we use. 

#### Reshapable clusters

The hadoop cluster definition we use at infochimps for production runs uses its HDFS ONLY a scratch pad - anything we want to keep goes into S3.

This lets us do stupid, dangerous, awesome things like:

* spin up a few dozen c1.xlarge CPU-intensive machines, parse a ton of data,
  store it back into S3.
* blow all the workers away and reformat the namenode with the `/etc/hadoop/conf/nuke_hdfs_from_orbit_its_the_only_way_to_be_sure.sh.erb` shell script.
* spin up a cluster of m2.2xlarge memory-intensive machines to group and filter it, storing final results into S3.
* shut the entire cluster down before anyone in accounting notices.

#### Tasktracker-only workers

Who says your workers should also be datanodes? Sure, "bring the compute to the data" is the way the *robots* want you to do it, but a tasktracker-only node on an idle cluster is one you can kill with no repercussions.

This lets you blow up the size of your cluster and not have to wait later for nodes to decommission. Non-local map tasks obviously run slower-than-optimal, but we'd rather have sub-optimal robots than sub-optimal data scientists.

### Author:
      
Author:: Joshua Timberman (<joshua@opscode.com>), Flip Kromer (<flip@infochimps.org>), much code taken from Tom White (<tom@cloudera.com>)'s hadoop-ec2 scripts and Robert Berger (http://blog.ibd.com)'s blog posts.

Copyright:: 2009, Opscode, Inc; 2010, 2011 Infochimps, In

## Recipes 

* `add_cloudera_repo`        - Add Cloudera repo to package manager
* `cluster_conf`             - Configure cluster
* `datanode`                 - Installs Hadoop Datanode service
* `default`                  - Base configuration for hadoop_cluster
* `doc`                      - Installs Hadoop documentation
* `fake_topology`            - Pretend that groups of machines are on different racks so you can execute them without guilt
* `hdfs_fuse`                - Installs Hadoop HDFS Fuse service (regular filesystem access to HDFS files)
* `jobtracker`               - Installs Hadoop Jobtracker service
* `namenode`                 - Installs Hadoop Namenode service
* `secondarynn`              - Installs Hadoop Secondary Namenode service
* `simple_dashboard`         - Simple Dashboard
* `tasktracker`              - Installs Hadoop Tasktracker service
* `wait_on_hdfs_safemode`    - Wait on HDFS Safemode -- insert between cookbooks to ensure HDFS is available

## Integration

Supports platforms: debian and ubuntu

Cookbook dependencies:

* java
* apt
* runit
* volumes
* tuning
* metachef
* dashpot


## Attributes

* `[:cluster_size]`                   - Number of machines in the cluster (default: "5")
  - Number of machines in the cluster. This is used to size things like handler counts, etc.
* `[:apt][:cloudera][:force_distro]`  - Override the distro name apt uses to look up repos (default: "maverick")
  - Typically, leave this blank. However if (as is the case in Nov 2011) you are on natty but Cloudera's repo only has packages up to maverick, use this to override.
* `[:apt][:cloudera][:release_name]`  - Release identifier (eg cdh3u2) of the cloudera repo to use. See also hadoop/deb_version (default: "cdh3u2")
* `[:hadoop][:handle]`                - Version prefix for the daemons and other components (default: "hadoop-0.20")
  - Cloudera distros have a prefix most (but not all) things with. This helps isolate the times they say 'hadoop-0.20' vs. 'hadoop'
* `[:hadoop][:deb_version]`           - Apt revision identifier (eg 0.20.2+923.142-1~maverick-cdh3) of the specific cloudera apt to use. See also apt/release_name (default: "0.20.2+923.142-1~maverick-cdh3")
* `[:hadoop][:dfs_replication]`       - Default HDFS replication factor (default: "3")
  - HDFS blocks are by default reproduced to this many machines.
* `[:hadoop][:reducer_parallel_copies]` -  (default: "10")
* `[:hadoop][:compress_output]`       -  (default: "false")
* `[:hadoop][:compress_output_type]`  -  (default: "BLOCK")
* `[:hadoop][:compress_output_codec]` -  (default: "org.apache.hadoop.io.compress.DefaultCodec")
* `[:hadoop][:compress_mapout]`       -  (default: "true")
* `[:hadoop][:compress_mapout_codec]` -  (default: "org.apache.hadoop.io.compress.DefaultCodec")
* `[:hadoop][:log_retention_hours]`   -  (default: "24")
  - See [Hadoop Log Location and Retention](http://www.cloudera.com/blog/2010/11/hadoop-log-location-and-retention) for more.
* `[:hadoop][:java_heap_size_max]`    -  (default: "1000")
  - uses /etc/default/hadoop-0.20 to set the hadoop daemon's java_heap_size_max
* `[:hadoop][:min_split_size]`        -  (default: "134217728")
  - You may wish to set the following to the same as your HDFS block size, esp if
    you're seeing issues with s3:// turning 1TB files into 30_000+ map tasks
* `[:hadoop][:s3_block_size]`         - fs.s3n.block.size (default: "134217728")
  - Block size to use when reading files using the native S3 filesystem (s3n: URIs).
* `[:hadoop][:hdfs_block_size]`       - dfs.block.size (default: "134217728")
  - The default block size for new files
* `[:hadoop][:max_map_tasks]`         -  (default: "3")
* `[:hadoop][:max_reduce_tasks]`      -  (default: "2")
* `[:hadoop][:java_child_opts]`       -  (default: "-Xmx2432m -Xss128k -XX:+UseCompressedOops -XX:MaxNewSize=200m -server")
* `[:hadoop][:java_child_ulimit]`     -  (default: "7471104")
* `[:hadoop][:io_sort_factor]`        -  (default: "25")
* `[:hadoop][:io_sort_mb]`            -  (default: "250")
* `[:hadoop][:extra_classpaths]`      - 
  - Other recipes can add to this under their own special key, for instance
    node[:hadoop][:extra_classpaths][:hbase] = '/usr/lib/hbase/hbase.jar:/usr/lib/hbase/lib/zookeeper.jar:/usr/lib/hbase/conf'
* `[:hadoop][:home_dir]`              -  (default: "/usr/lib/hadoop")
* `[:hadoop][:conf_dir]`              -  (default: "/etc/hadoop/conf")
* `[:hadoop][:pid_dir]`               -  (default: "/var/run/hadoop")
* `[:hadoop][:log_dir]`               - 
* `[:hadoop][:tmp_dir]`               - 
* `[:hadoop][:user]`                  -  (default: "hdfs")
* `[:hadoop][:define_topology]`       - 
  - define a rack topology? if false (default), all nodes are in the same 'rack'.
* `[:hadoop][:jobtracker][:handler_count]` -  (default: "40")
* `[:hadoop][:jobtracker][:run_state]` -  (default: "stop")
* `[:hadoop][:jobtracker][:java_heap_size_max]` - 
* `[:hadoop][:jobtracker][:system_hdfsdir]` -  (default: "/hadoop/mapred/system")
* `[:hadoop][:jobtracker][:staging_hdfsdir]` -  (default: "/hadoop/mapred/system")
* `[:hadoop][:jobtracker][:port]`     -  (default: "8021")
* `[:hadoop][:jobtracker][:dash_port]` -  (default: "50030")
* `[:hadoop][:jobtracker][:user]`     -  (default: "mapred")
* `[:hadoop][:jobtracker][:jmx_dash_port]` -  (default: "8008")
* `[:hadoop][:namenode][:handler_count]` -  (default: "40")
* `[:hadoop][:namenode][:run_state]`  -  (default: "stop")
  - What states to set for services.
    You want to bring the big daemons up deliberately on initial start.
    Override in your cluster definition when things are stable.
* `[:hadoop][:namenode][:java_heap_size_max]` - 
* `[:hadoop][:namenode][:port]`       -  (default: "8020")
* `[:hadoop][:namenode][:dash_port]`  -  (default: "50070")
* `[:hadoop][:namenode][:user]`       -  (default: "hdfs")
* `[:hadoop][:namenode][:data_dirs]`  - 
  - These are handled by volumes, which imprints them on the node.
    If you set an explicit value it will be used and no discovery is done.
    Chef Attr                    Owner           Permissions  Path                                     Hadoop Attribute
    [:namenode   ][:data_dir]    hdfs:hadoop     drwx------   {persistent_vols}/hadoop/hdfs/name       dfs.name.dir
    [:sec..node  ][:data_dir]    hdfs:hadoop     drwxr-xr-x   {persistent_vols}/hadoop/hdfs/secondary  fs.checkpoint.dir
    [:datanode   ][:data_dir]    hdfs:hadoop     drwxr-xr-x   {persistent_vols}/hadoop/hdfs/data       dfs.data.dir
    [:tasktracker][:scratch_dir] mapred:hadoop   drwxr-xr-x   {scratch_vols   }/hadoop/hdfs/name       mapred.local.dir
    [:jobtracker ][:system_hdfsdir]  mapred:hadoop   drwxr-xr-x   {!!HDFS!!       }/hadoop/mapred/system   mapred.system.dir
    [:jobtracker ][:staging_hdfsdir] mapred:hadoop   drwxr-xr-x   {!!HDFS!!       }/hadoop/mapred/staging  mapred.system.dir
    Important: In CDH3, the mapred.system.dir directory must be located inside a directory that is owned by mapred. For example, if mapred.system.dir is specified as /mapred/system, then /mapred must be owned by mapred. Don't, for example, specify /mrsystem as mapred.system.dir because you don't want / owned by mapred.
* `[:hadoop][:namenode][:jmx_dash_port]` -  (default: "8004")
* `[:hadoop][:datanode][:handler_count]` -  (default: "8")
* `[:hadoop][:datanode][:run_state]`  -  (default: "start")
  - You can just kick off the worker daemons, they'll retry. On a full-cluster
    stop/start (or any other time the main daemons' ip address changes) however
    you will need to converge chef and then restart them all.
* `[:hadoop][:datanode][:java_heap_size_max]` - 
* `[:hadoop][:datanode][:port]`       -  (default: "50010")
* `[:hadoop][:datanode][:ipc_port]`   -  (default: "50020")
* `[:hadoop][:datanode][:dash_port]`  -  (default: "50075")
* `[:hadoop][:datanode][:user]`       -  (default: "hdfs")
* `[:hadoop][:datanode][:data_dirs]`  - 
* `[:hadoop][:datanode][:jmx_dash_port]` -  (default: "8006")
* `[:hadoop][:tasktracker][:http_threads]` -  (default: "32")
* `[:hadoop][:tasktracker][:run_state]` -  (default: "start")
* `[:hadoop][:tasktracker][:java_heap_size_max]` - 
* `[:hadoop][:tasktracker][:dash_port]` -  (default: "50060")
* `[:hadoop][:tasktracker][:user]`    -  (default: "mapred")
* `[:hadoop][:tasktracker][:scratch_dirs]` - 
* `[:hadoop][:tasktracker][:jmx_dash_port]` -  (default: "8009")
* `[:hadoop][:secondarynn][:run_state]` -  (default: "stop")
* `[:hadoop][:secondarynn][:java_heap_size_max]` - 
* `[:hadoop][:secondarynn][:dash_port]` -  (default: "50090")
* `[:hadoop][:secondarynn][:user]`    -  (default: "hdfs")
* `[:hadoop][:secondarynn][:data_dirs]` - 
* `[:hadoop][:secondarynn][:jmx_dash_port]` -  (default: "8005")
* `[:hadoop][:hdfs_fuse][:run_state]` -  (default: "stop")
* `[:hadoop][:balancer][:run_state]`  -  (default: "stop")
* `[:hadoop][:balancer][:jmx_dash_port]` -  (default: "8007")
* `[:hadoop][:balancer][:max_bandwidth]` -  (default: "1048576")
  - bytes per second -- 1MB/s by default
* `[:groups][:hadoop][:gid]`          -  (default: "300")
* `[:groups][:supergroup][:gid]`      -  (default: "301")
* `[:groups][:hdfs][:gid]`            -  (default: "302")
* `[:groups][:mapred][:gid]`          -  (default: "303")
* `[:java][:java_home]`               -  (default: "/usr/lib/jvm/java-6-sun/jre")
* `[:users][:hdfs][:uid]`             -  (default: "302")
* `[:users][:mapred][:uid]`           -  (default: "303")
* `[:tuning][:ulimit][:hdfs]`         - 
* `[:tuning][:ulimit][:mapred]`       - 

## License and Author

Author::                Philip (flip) Kromer - Infochimps, Inc (<coders@infochimps.com>)
Copyright::             2011, Philip (flip) Kromer - Infochimps, Inc

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
