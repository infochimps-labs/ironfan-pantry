maintainer       "Philip (flip) Kromer - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "3.0.5"

description      "Hadoop: distributed massive-scale data processing framework. Store and analyze terabyte-scale datasets with ease"

depends          "java"
depends          "apt"
depends          "runit"
depends          "volumes"
depends          "tuning"
depends          "metachef"
depends          "dashpot"

recipe           "hadoop_cluster::default",            "Base configuration for hadoop_cluster"
recipe           "hadoop_cluster::add_cloudera_repo",  "Add Cloudera repo to package manager"
recipe           "hadoop_cluster::cluster_conf",       "Configure cluster"
recipe           "hadoop_cluster::datanode",           "Installs Hadoop Datanode service"
recipe           "hadoop_cluster::secondarynn",        "Installs Hadoop Secondary Namenode service"
recipe           "hadoop_cluster::tasktracker",        "Installs Hadoop Tasktracker service"
recipe           "hadoop_cluster::jobtracker",         "Installs Hadoop Jobtracker service"
recipe           "hadoop_cluster::namenode",           "Installs Hadoop Namenode service"
recipe           "hadoop_cluster::doc",                "Installs Hadoop documentation"
recipe           "hadoop_cluster::hdfs_fuse",          "Installs Hadoop HDFS Fuse service (regular filesystem access to HDFS files)"
recipe           "hadoop_cluster::wait_on_hdfs_safemode", "Wait on HDFS Safemode -- insert between cookbooks to ensure HDFS is available"
recipe           "hadoop_cluster::simple_dashboard",   "Simple Dashboard"
recipe           "hadoop_cluster::fake_topology",      "Pretend that groups of machines are on different racks so you can execute them without guilt"

%w[ debian ubuntu ].each do |os|
  supports os
end

attribute "cluster_size",
  :display_name          => "Number of machines in the cluster",
  :description           => "Number of machines in the cluster. This is used to size things like handler counts, etc.",
  :default               => "5"

attribute "apt/cloudera/force_distro",
  :display_name          => "Override the distro name apt uses to look up repos",
  :description           => "Typically, leave this blank. However if (as is the case in Nov 2011) you are on natty but Cloudera's repo only has packages up to maverick, use this to override.",
  :default               => "maverick"

attribute "apt/cloudera/release_name",
  :display_name          => "Release identifier (eg cdh3u2) of the cloudera repo to use. See also hadoop/deb_version",
  :description           => "Release identifier (eg cdh3u2) of the cloudera repo to use. See also hadoop/deb_version",
  :default               => "cdh3u2"

attribute "hadoop/handle",
  :display_name          => "Version prefix for the daemons and other components",
  :description           => "Cloudera distros have a prefix most (but not all) things with. This helps isolate the times they say 'hadoop-0.20' vs. 'hadoop'",
  :default               => "hadoop-0.20"

attribute "hadoop/deb_version",
  :display_name          => "Apt revision identifier (eg 0.20.2+923.142-1~maverick-cdh3) of the specific cloudera apt to use. See also apt/release_name",
  :description           => "Apt revision identifier (eg 0.20.2+923.142-1~maverick-cdh3) of the specific cloudera apt to use. See also apt/release_name",
  :default               => "0.20.2+923.142-1~maverick-cdh3"

attribute "hadoop/dfs_replication",
  :display_name          => "Default HDFS replication factor",
  :description           => "HDFS blocks are by default reproduced to this many machines.",
  :default               => "3"

attribute "hadoop/reducer_parallel_copies",
  :display_name          => "",
  :description           => "",
  :default               => "10"

attribute "hadoop/compress_output",
  :display_name          => "",
  :description           => "",
  :default               => "false"

attribute "hadoop/compress_output_type",
  :display_name          => "",
  :description           => "",
  :default               => "BLOCK"

attribute "hadoop/compress_output_codec",
  :display_name          => "",
  :description           => "",
  :default               => "org.apache.hadoop.io.compress.DefaultCodec"

attribute "hadoop/compress_mapout",
  :display_name          => "",
  :description           => "",
  :default               => "true"

attribute "hadoop/compress_mapout_codec",
  :display_name          => "",
  :description           => "",
  :default               => "org.apache.hadoop.io.compress.DefaultCodec"

attribute "hadoop/log_retention_hours",
  :display_name          => "",
  :description           => "See [Hadoop Log Location and Retention](http://www.cloudera.com/blog/2010/11/hadoop-log-location-and-retention) for more.",
  :default               => "24"

attribute "hadoop/java_heap_size_max",
  :display_name          => "",
  :description           => "uses /etc/default/hadoop-0.20 to set the hadoop daemon's java_heap_size_max",
  :default               => "1000"

attribute "hadoop/min_split_size",
  :display_name          => "",
  :description           => "You may wish to set the following to the same as your HDFS block size, esp if\nyou're seeing issues with s3:// turning 1TB files into 30_000+ map tasks",
  :default               => "134217728"

attribute "hadoop/s3_block_size",
  :display_name          => "fs.s3n.block.size",
  :description           => "Block size to use when reading files using the native S3 filesystem (s3n: URIs).",
  :default               => "134217728"

attribute "hadoop/hdfs_block_size",
  :display_name          => "dfs.block.size",
  :description           => "The default block size for new files",
  :default               => "134217728"

attribute "hadoop/max_map_tasks",
  :display_name          => "",
  :description           => "",
  :default               => "3"

attribute "hadoop/max_reduce_tasks",
  :display_name          => "",
  :description           => "",
  :default               => "2"

attribute "hadoop/java_child_opts",
  :display_name          => "",
  :description           => "",
  :default               => "-Xmx2432m -Xss128k -XX:+UseCompressedOops -XX:MaxNewSize=200m -server"

attribute "hadoop/java_child_ulimit",
  :display_name          => "",
  :description           => "",
  :default               => "7471104"

attribute "hadoop/io_sort_factor",
  :display_name          => "",
  :description           => "",
  :default               => "25"

attribute "hadoop/io_sort_mb",
  :display_name          => "",
  :description           => "",
  :default               => "250"

attribute "hadoop/extra_classpaths",
  :display_name          => "",
  :description           => "Other recipes can add to this under their own special key, for instance\nnode[:hadoop][:extra_classpaths][:hbase] = '/usr/lib/hbase/hbase.jar:/usr/lib/hbase/lib/zookeeper.jar:/usr/lib/hbase/conf'",
  :default               => ""

attribute "hadoop/home_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/usr/lib/hadoop"

attribute "hadoop/conf_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/etc/hadoop/conf"

attribute "hadoop/pid_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/run/hadoop"

attribute "hadoop/log_dir",
  :display_name          => "",
  :description           => "",
  :default               => ""

attribute "hadoop/tmp_dir",
  :display_name          => "",
  :description           => "",
  :default               => ""

attribute "hadoop/user",
  :display_name          => "",
  :description           => "",
  :default               => "hdfs"

attribute "hadoop/define_topology",
  :display_name          => "",
  :description           => "define a rack topology? if false (default), all nodes are in the same 'rack'.",
  :default               => ""

attribute "hadoop/jobtracker/handler_count",
  :display_name          => "",
  :description           => "",
  :default               => "40"

attribute "hadoop/jobtracker/run_state",
  :display_name          => "",
  :description           => "",
  :default               => "stop"

attribute "hadoop/jobtracker/java_heap_size_max",
  :display_name          => "",
  :description           => "",
  :default               => ""

attribute "hadoop/jobtracker/system_hdfsdir",
  :display_name          => "",
  :description           => "",
  :default               => "/hadoop/mapred/system"

attribute "hadoop/jobtracker/staging_hdfsdir",
  :display_name          => "",
  :description           => "",
  :default               => "/hadoop/mapred/system"

attribute "hadoop/jobtracker/port",
  :display_name          => "",
  :description           => "",
  :default               => "8021"

attribute "hadoop/jobtracker/dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "50030"

attribute "hadoop/jobtracker/user",
  :display_name          => "",
  :description           => "",
  :default               => "mapred"

attribute "hadoop/jobtracker/jmx_dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "8008"

attribute "hadoop/namenode/handler_count",
  :display_name          => "",
  :description           => "",
  :default               => "40"

attribute "hadoop/namenode/run_state",
  :display_name          => "",
  :description           => "What states to set for services.\nYou want to bring the big daemons up deliberately on initial start.\nOverride in your cluster definition when things are stable.",
  :default               => "stop"

attribute "hadoop/namenode/java_heap_size_max",
  :display_name          => "",
  :description           => "",
  :default               => ""

attribute "hadoop/namenode/port",
  :display_name          => "",
  :description           => "",
  :default               => "8020"

attribute "hadoop/namenode/dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "50070"

attribute "hadoop/namenode/user",
  :display_name          => "",
  :description           => "",
  :default               => "hdfs"

attribute "hadoop/namenode/data_dirs",
  :display_name          => "",
  :description           => "These are handled by volumes, which imprints them on the node.\nIf you set an explicit value it will be used and no discovery is done.\nChef Attr                    Owner           Permissions  Path                                     Hadoop Attribute\n[:namenode   ][:data_dir]    hdfs:hadoop     drwx------   {persistent_vols}/hadoop/hdfs/name       dfs.name.dir\n[:sec..node  ][:data_dir]    hdfs:hadoop     drwxr-xr-x   {persistent_vols}/hadoop/hdfs/secondary  fs.checkpoint.dir\n[:datanode   ][:data_dir]    hdfs:hadoop     drwxr-xr-x   {persistent_vols}/hadoop/hdfs/data       dfs.data.dir\n[:tasktracker][:scratch_dir] mapred:hadoop   drwxr-xr-x   {scratch_vols   }/hadoop/hdfs/name       mapred.local.dir\n[:jobtracker ][:system_hdfsdir]  mapred:hadoop   drwxr-xr-x   {!!HDFS!!       }/hadoop/mapred/system   mapred.system.dir\n[:jobtracker ][:staging_hdfsdir] mapred:hadoop   drwxr-xr-x   {!!HDFS!!       }/hadoop/mapred/staging  mapred.system.dir\nImportant: In CDH3, the mapred.system.dir directory must be located inside a directory that is owned by mapred. For example, if mapred.system.dir is specified as /mapred/system, then /mapred must be owned by mapred. Don't, for example, specify /mrsystem as mapred.system.dir because you don't want / owned by mapred.",
  :default               => ""

attribute "hadoop/namenode/jmx_dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "8004"

attribute "hadoop/datanode/handler_count",
  :display_name          => "",
  :description           => "",
  :default               => "8"

attribute "hadoop/datanode/run_state",
  :display_name          => "",
  :description           => "You can just kick off the worker daemons, they'll retry. On a full-cluster\nstop/start (or any other time the main daemons' ip address changes) however\nyou will need to converge chef and then restart them all.",
  :type                  => "array",
  :default               => "start"

attribute "hadoop/datanode/java_heap_size_max",
  :display_name          => "",
  :description           => "",
  :default               => ""

attribute "hadoop/datanode/port",
  :display_name          => "",
  :description           => "",
  :default               => "50010"

attribute "hadoop/datanode/ipc_port",
  :display_name          => "",
  :description           => "",
  :default               => "50020"

attribute "hadoop/datanode/dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "50075"

attribute "hadoop/datanode/user",
  :display_name          => "",
  :description           => "",
  :default               => "hdfs"

attribute "hadoop/datanode/data_dirs",
  :display_name          => "",
  :description           => "",
  :default               => ""

attribute "hadoop/datanode/jmx_dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "8006"

attribute "hadoop/tasktracker/http_threads",
  :display_name          => "",
  :description           => "",
  :default               => "32"

attribute "hadoop/tasktracker/run_state",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => "start"

attribute "hadoop/tasktracker/java_heap_size_max",
  :display_name          => "",
  :description           => "",
  :default               => ""

attribute "hadoop/tasktracker/dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "50060"

attribute "hadoop/tasktracker/user",
  :display_name          => "",
  :description           => "",
  :default               => "mapred"

attribute "hadoop/tasktracker/scratch_dirs",
  :display_name          => "",
  :description           => "",
  :default               => ""

attribute "hadoop/tasktracker/jmx_dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "8009"

attribute "hadoop/secondarynn/run_state",
  :display_name          => "",
  :description           => "",
  :default               => "stop"

attribute "hadoop/secondarynn/java_heap_size_max",
  :display_name          => "",
  :description           => "",
  :default               => ""

attribute "hadoop/secondarynn/dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "50090"

attribute "hadoop/secondarynn/user",
  :display_name          => "",
  :description           => "",
  :default               => "hdfs"

attribute "hadoop/secondarynn/data_dirs",
  :display_name          => "",
  :description           => "",
  :default               => ""

attribute "hadoop/secondarynn/jmx_dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "8005"

attribute "hadoop/hdfs_fuse/run_state",
  :display_name          => "",
  :description           => "",
  :default               => "stop"

attribute "hadoop/balancer/run_state",
  :display_name          => "",
  :description           => "",
  :default               => "stop"

attribute "hadoop/balancer/jmx_dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "8007"

attribute "hadoop/balancer/max_bandwidth",
  :display_name          => "",
  :description           => "bytes per second -- 1MB/s by default",
  :default               => "1048576"

attribute "groups/hadoop/gid",
  :display_name          => "",
  :description           => "",
  :default               => "300"

attribute "groups/supergroup/gid",
  :display_name          => "",
  :description           => "",
  :default               => "301"

attribute "groups/hdfs/gid",
  :display_name          => "",
  :description           => "",
  :default               => "302"

attribute "groups/mapred/gid",
  :display_name          => "",
  :description           => "",
  :default               => "303"

attribute "java/java_home",
  :display_name          => "",
  :description           => "",
  :default               => "/usr/lib/jvm/java-6-sun/jre"

attribute "users/hdfs/uid",
  :display_name          => "",
  :description           => "",
  :default               => "302"

attribute "users/mapred/uid",
  :display_name          => "",
  :description           => "",
  :default               => "303"

attribute "tuning/ulimit/hdfs",
  :display_name          => "",
  :description           => "",
  :type                  => "hash",
  :default               => {:nofile=>{:both=>32768}, :nproc=>{:both=>50000}}

attribute "tuning/ulimit/mapred",
  :display_name          => "",
  :description           => "",
  :type                  => "hash",
  :default               => {:nofile=>{:both=>32768}, :nproc=>{:both=>50000}}
