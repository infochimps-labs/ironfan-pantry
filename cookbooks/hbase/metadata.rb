maintainer       "Chris Howe - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "3.0.4"

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
  :description           => "total size of the JVM heap (master)",
  :default               => "1000m"

attribute "hbase/master/java_heap_size_new",
  :display_name          => "",
  :description           => "size of the JVM \"New Generation/Eden\" heap segment (master)",
  :default               => "256m"

attribute "hbase/master/gc_tuning_opts",
  :display_name          => "",
  :description           => "JVM garbage collection tuning for the hbase master",
  :default               => "-XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:+AggressiveOpts"

attribute "hbase/master/gc_log_opts",
  :display_name          => "",
  :description           => "What details to log about JVM garbage collection statistics for the hbase master",
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
  :description           => "total size of the JVM heap (regionserver)",
  :default               => "2000m"

attribute "hbase/regionserver/java_heap_size_new",
  :display_name          => "",
  :description           => "size of the JVM \"New Generation/Eden\" heap segment (regionserver)",
  :default               => "256m"

attribute "hbase/regionserver/gc_tuning_opts",
  :display_name          => "",
  :description           => "JVM garbage collection tuning for the hbase regionserver",
  :default               => "-XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:+AggressiveOpts -XX:CMSInitiatingOccupancyFraction=88"

attribute "hbase/regionserver/gc_log_opts",
  :display_name          => "",
  :description           => "What details to log about JVM garbage collection statistics for the hbase regionserver",
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
  :description           => "hbase.regionserver.lease.period (default 60000) -- HRegion server lease period in\nmilliseconds. Default is 60 seconds. Clients must report in within this period else\nthey are considered dead.",
  :default               => "60000"

attribute "hbase/regionserver/handler_count",
  :display_name          => "",
  :description           => "hbase.regionserver.handler.count (default 10) -- Count of RPC Server instances spun up\non RegionServers. Same property is used by the Master for count of master handlers.",
  :default               => "10"

attribute "hbase/regionserver/split_limit",
  :display_name          => "",
  :description           => "hbase.regionserver.regionSplitLimit (default 2147483647) -- Limit for the number of\nregions after which no more region splitting should take place. This is not a hard\nlimit for the number of regions but acts as a guideline for the regionserver to stop\nsplitting after a certain limit. Default is set to MAX_INT; i.e. do not block\nsplitting.",
  :default               => "2147483647"

attribute "hbase/regionserver/msg_period",
  :display_name          => "",
  :description           => "hbase.regionserver.msginterval (default 3000) -- Interval between messages from the\nRegionServer to Master in milliseconds.",
  :default               => "3000"

attribute "hbase/regionserver/log_flush_period",
  :display_name          => "",
  :description           => "hbase.regionserver.optionallogflushinterval (default 1000) -- Sync the HLog to the HDFS\nafter this interval if it has not accumulated enough entries to trigger a\nsync. Default 1 second. Units: milliseconds.",
  :default               => "1000"

attribute "hbase/regionserver/logroll_period",
  :display_name          => "",
  :description           => "hbase.regionserver.logroll.period (default 3600000) -- Period at which we will roll the\ncommit log regardless of how many edits it has.",
  :default               => "3600000"

attribute "hbase/regionserver/split_check_period",
  :display_name          => "",
  :description           => "hbase.regionserver.thread.splitcompactcheckfrequency (default 20000) -- How often a\nregion server runs the split/compaction check.",
  :default               => "20000"

attribute "hbase/regionserver/worker_period",
  :display_name          => "",
  :description           => "hbase.server.thread.wakefrequency (default 10_000) -- Time to sleep in between searches\nfor work (in milliseconds).  Used as sleep interval by service threads such as log roller.",
  :default               => "10000"

attribute "hbase/regionserver/balancer_period",
  :display_name          => "",
  :description           => "hbase.balancer.period (default 300000) -- Period at which the region balancer runs in\nthe Master.",
  :default               => "300000"

attribute "hbase/regionserver/balancer_slop",
  :display_name          => "",
  :description           => "hbase.regions.slop (default 0) -- Rebalance if any regionserver has more than\naverage + (average * slop) regions",
  :default               => "0"

attribute "hbase/regionserver/max_filesize",
  :display_name          => "",
  :description           => "hbase.hregion.max.filesize (default 268435456) -- Maximum HStoreFile size. If any one of\na column families' HStoreFiles has grown to exceed this value, the hosting HRegion is\nsplit in two.",
  :default               => "268435456"

attribute "hbase/regionserver/hfile_block_size",
  :display_name          => "",
  :description           => "hbase.mapreduce.hfileoutputformat.blocksize (default 65536) -- The mapreduce\nHFileOutputFormat writes storefiles/hfiles.  This is the minimum hfile blocksize to\nemit.  Usually in hbase, writing hfiles, the blocksize is gotten from the table schema\n(HColumnDescriptor) but in the mapreduce outputformat context, we don't have access to\nthe schema so get blocksize from Configuation.  The smaller you make the blocksize,\nthe bigger your index and the less you fetch on a random-access.  Set the blocksize\ndown if you have small cells and want faster random-access of individual cells.",
  :default               => "65536"

attribute "hbase/regionserver/required_codecs",
  :display_name          => "",
  :description           => "hbase.regionserver.codecs (default \"\") -- To have a RegionServer test a set of\ncodecs and fail-to-start if any code is missing or misinstalled, add the\nconfiguration hbase.regionserver.codecs to your hbase-site.xml with a value of\ncodecs to test on startup. For example if the hbase.regionserver.codecs value\nis \"lzo,gz\" and if lzo is not present or improperly installed, the misconfigured\nRegionServer will fail to start.",
  :default               => ""

attribute "hbase/regionserver/block_cache_size",
  :display_name          => "",
  :description           => "hfile.block.cache.size (default 0.2) -- Percentage of maximum heap (-Xmx setting) to\nallocate to block cache used by HFile/StoreFile. Default of 0.2 means allocate 20%.\nSet to 0 to disable.",
  :default               => "0.2"

attribute "hbase/regionserver/hash_type",
  :display_name          => "",
  :description           => "hbase.hash.type (default murmur) -- The hashing algorithm for use in HashFunction. Two\nvalues are supported now: murmur (MurmurHash) and jenkins (JenkinsHash).  Used by\nbloom filters.",
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
  :description           => "hbase.rest.readonly (default false) -- Defines the mode the REST server will be started\nin. Possible values are: false: All HTTP methods are permitted - GET/PUT/POST/DELETE.\ntrue: Only the GET method is permitted.",
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
  :description           => "zookeeper.session.timeout (default 180_000) -- ZooKeeper session timeout.  HBase passes\nthis to the zk quorum as suggested maximum time for a session.  See\nhttp://hadoop.apache.org/zookeeper/docs/current/zookeeperProgrammers.html#ch_zkSessions\n\"The client sends a requested timeout, the server responds with the timeout that it\ncan give the client. \" In milliseconds.",
  :default               => "180000"

attribute "hbase/zookeeper/znode_parent",
  :display_name          => "",
  :description           => "zookeeper.znode.parent (default \"/hbase\") -- Root ZNode for HBase in\nZooKeeper. All of HBase's ZooKeeper files that are configured with a\nrelative path will go under this node.  By default, all of HBase's ZooKeeper\nfile path are configured with a relative path, so they will all go under\nthis directory unless changed.",
  :default               => "/hbase"

attribute "hbase/zookeeper/znode_rootserver",
  :display_name          => "",
  :description           => "zookeeper.znode.rootserver (default root-region-server) -- Path to ZNode\nholding root region location. This is written by the master and read by\nclients and region servers. If a relative path is given, the parent folder\nwill be ${zookeeper.znode.parent}. By default, this means the root location\nis stored at /hbase/root-region-server.",
  :default               => "root-region-server"

attribute "hbase/zookeeper/max_client_connections",
  :display_name          => "",
  :description           => "hbase.zookeeper.property.maxClientCnxns (default 2000) -- Limit on number of concurrent\nconnections (at the socket level) that a single client, identified by IP address, may\nmake to a single member of the ZooKeeper ensemble. Set high to avoid zk connection\nissues running standalone and pseudo-distributed.",
  :default               => "2000"

attribute "hbase/client/write_buffer",
  :display_name          => "",
  :description           => "hbase.client.write.buffer (default 2097152) Default size of the HTable client write\nbuffer in bytes.  A bigger buffer takes more memory -- on both the client and server\nside since server instantiates the passed write buffer to process it -- but a larger\nbuffer size reduces the number of RPCs made.  For an estimate of server-side\nmemory-used, evaluate\nhbase.client.write.buffer * hbase.regionserver.handler.count",
  :default               => "2097152"

attribute "hbase/client/pause_period_ms",
  :display_name          => "",
  :description           => "hbase.client.pause (default 1000) -- General client pause value.  Used mostly as value\nto wait before running a retry of a failed get, region lookup, etc.",
  :default               => "1000"

attribute "hbase/client/retry_count",
  :display_name          => "",
  :description           => "hbase.client.retries.number (default 10) -- Maximum retries.  Used as maximum for all\nretryable operations such as fetching of the root region from root region server,\ngetting a cell's value, starting a row update, etc.",
  :default               => "10"

attribute "hbase/client/scanner_prefetch_rows",
  :display_name          => "",
  :description           => "hbase.client.scanner.caching (default 1) -- Number of rows that will be fetched when\ncalling next on a scanner if it is not served from (local, client) memory. Higher\ncaching values will enable faster scanners but will eat up more memory and some calls\nof next may take longer and longer times when the cache is empty.  Do not set this\nvalue such that the time between invocations is greater than the scanner timeout;\ni.e. hbase.regionserver.lease.period",
  :default               => "1"

attribute "hbase/client/max_keyvalue_size",
  :display_name          => "",
  :description           => "hbase.client.keyvalue.maxsize (default 10485760) -- Specifies the combined maximum\nallowed size of a KeyValue instance. This is to set an upper boundary for a single\nentry saved in a storage file. Since they cannot be split it helps avoiding that a\nregion cannot be split any further because the data is too large. It seems wise to set\nthis to a fraction of the maximum region size. Setting it to zero or less disables the\ncheck.",
  :default               => "10485760"

attribute "hbase/memstore/flush_upper_heap_pct",
  :display_name          => "",
  :description           => "hbase.regionserver.global.memstore.upperLimit (default 0.4) -- Maximum size of all\nmemstores in a region server before new updates are blocked and flushes are\nforced. Defaults to 40% of heap",
  :default               => "0.4"

attribute "hbase/memstore/flush_lower_heap_pct",
  :display_name          => "",
  :description           => "hbase.regionserver.global.memstore.lowerLimit (default 0.35) -- When memstores are being\nforced to flush to make room in memory, keep flushing until we hit this mark. Defaults\nto 35% of heap.  This value equal to hbase.regionserver.global.memstore.upperLimit\ncauses the minimum possible flushing to occur when updates are blocked due to memstore\nlimiting.",
  :default               => "0.35"

attribute "hbase/memstore/flush_size_trigger",
  :display_name          => "",
  :description           => "hbase.hregion.memstore.flush.size (default 67108864) -- Memstore will be flushed to disk\nif size of the memstore exceeds this number of bytes.  Value is checked by a thread\nthat runs every hbase.server.thread.wakefrequency.",
  :default               => "67108864"

attribute "hbase/memstore/preflush_trigger",
  :display_name          => "",
  :description           => "hbase.hregion.preclose.flush.size (default 5 mb) -- If the memstores in a region are\nthis size or larger when we go to close, run a \"pre-flush\" to clear out memstores\nbefore we put up the region closed flag and take the region offline.  On close, a\nflush is run under the close flag to empty memory.  During this time the region is\noffline and we are not taking on any writes.  If the memstore content is large, this\nflush could take a long time to complete.  The preflush is meant to clean out the bulk\nof the memstore before putting up the close flag and taking the region offline so the\nflush that runs under the close flag has little to do.",
  :default               => "5242880"

attribute "hbase/memstore/flush_stall_trigger",
  :display_name          => "",
  :description           => "hbase.hregion.memstore.block.multiplier (default 2) -- Block updates if memstore has\nhbase.hregion.block.memstore time hbase.hregion.flush.size bytes.  Useful preventing\nrunaway memstore during spikes in update traffic.  Without an upper-bound, memstore\nfills such that when it flushes the resultant flush files take a long time to compact\nor split, or worse, we OOME.",
  :default               => "8"

attribute "hbase/memstore/mslab_enabled",
  :display_name          => "",
  :description           => "hbase.hregion.memstore.mslab.enabled (default false) -- Experimental: Enables the\nMemStore-Local Allocation Buffer, a feature which works to prevent heap fragmentation\nunder heavy write loads. This can reduce the frequency of stop-the-world GC pauses on\nlarge heaps.",
  :default               => ""

attribute "hbase/compaction/files_trigger",
  :display_name          => "",
  :description           => "hbase.hstore.compactionThreshold (default 3) -- If more than this number of HStoreFiles\nin any one HStore (one HStoreFile is written per flush of memstore) then a compaction\nis run to rewrite all HStoreFiles files as one.  Larger numbers put off compaction but\nwhen it runs, it takes longer to complete.",
  :default               => "3"

attribute "hbase/compaction/pause_trigger",
  :display_name          => "",
  :description           => "hbase.hstore.blockingStoreFiles (default 7) -- If more than this number of StoreFiles in\nany one Store (one StoreFile is written per flush of MemStore) then updates are\nblocked for this HRegion until a compaction is completed, or until\nhbase.hstore.blockingWaitTime has been exceeded.",
  :default               => "7"

attribute "hbase/compaction/pause_time",
  :display_name          => "",
  :description           => "hbase.hstore.blockingWaitTime (default 90_000) -- The time an HRegion will block updates\nfor after hitting the StoreFile limit defined by hbase.hstore.blockingStoreFiles.\nAfter this time has elapsed, the HRegion will stop blocking updates even if a\ncompaction has not been completed.  Default: 90 seconds.",
  :default               => "90000"

attribute "hbase/compaction/max_combine_files",
  :display_name          => "",
  :description           => "hbase.hstore.compaction.max (default 10) -- Max number of HStoreFiles to compact per\n'minor' compaction.",
  :default               => "10"

attribute "hbase/compaction/period",
  :display_name          => "",
  :description           => "hbase.hregion.majorcompaction (default 86400000) -- The time (in miliseconds) between\n'major' compactions of all HStoreFiles in a region.  Default: 1 day.  Set to 0 to\ndisable automated major compactions.",
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
