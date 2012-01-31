# hbase chef cookbook

HBase: a massively-scalable high-throughput datastore based on the Hadoop HDFS

## Overview

Installs/Configures HBase

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
  - total size of the JVM heap (master)
* `[:hbase][:master][:java_heap_size_new]` -  (default: "256m")
  - size of the JVM "New Generation/Eden" heap segment (master)
* `[:hbase][:master][:gc_tuning_opts]` -  (default: "-XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:+AggressiveOpts")
  - JVM garbage collection tuning for the hbase master
* `[:hbase][:master][:gc_log_opts]`   -  (default: "-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps")
  - What details to log about JVM garbage collection statistics for the hbase master
* `[:hbase][:master][:run_state]`     -  (default: "start")
* `[:hbase][:master][:port]`          -  (default: "60000")
* `[:hbase][:master][:dash_port]`     -  (default: "60010")
* `[:hbase][:master][:jmx_dash_port]` -  (default: "10101")
* `[:hbase][:regionserver][:java_heap_size_max]` -  (default: "2000m")
  - total size of the JVM heap (regionserver)
* `[:hbase][:regionserver][:java_heap_size_new]` -  (default: "256m")
  - size of the JVM "New Generation/Eden" heap segment (regionserver)
* `[:hbase][:regionserver][:gc_tuning_opts]` -  (default: "-XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:+AggressiveOpts -XX:CMSInitiatingOccupancyFraction=88")
  - JVM garbage collection tuning for the hbase regionserver
* `[:hbase][:regionserver][:gc_log_opts]` -  (default: "-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps")
  - What details to log about JVM garbage collection statistics for the hbase regionserver
* `[:hbase][:regionserver][:run_state]` -  (default: "start")
* `[:hbase][:regionserver][:port]`    -  (default: "60020")
* `[:hbase][:regionserver][:dash_port]` -  (default: "60030")
* `[:hbase][:regionserver][:jmx_dash_port]` -  (default: "10102")
* `[:hbase][:regionserver][:lease_period]` -  (default: "60000")
  - hbase.regionserver.lease.period (default 60000) -- HRegion server lease period in
    milliseconds. Default is 60 seconds. Clients must report in within this period else
    they are considered dead.
* `[:hbase][:regionserver][:handler_count]` -  (default: "10")
  - hbase.regionserver.handler.count (default 10) -- Count of RPC Server instances spun up
    on RegionServers. Same property is used by the Master for count of master handlers.
* `[:hbase][:regionserver][:split_limit]` -  (default: "2147483647")
  - hbase.regionserver.regionSplitLimit (default 2147483647) -- Limit for the number of
    regions after which no more region splitting should take place. This is not a hard
    limit for the number of regions but acts as a guideline for the regionserver to stop
    splitting after a certain limit. Default is set to MAX_INT; i.e. do not block
    splitting.
* `[:hbase][:regionserver][:msg_period]` -  (default: "3000")
  - hbase.regionserver.msginterval (default 3000) -- Interval between messages from the
    RegionServer to Master in milliseconds.
* `[:hbase][:regionserver][:log_flush_period]` -  (default: "1000")
  - hbase.regionserver.optionallogflushinterval (default 1000) -- Sync the HLog to the HDFS
    after this interval if it has not accumulated enough entries to trigger a
    sync. Default 1 second. Units: milliseconds.
* `[:hbase][:regionserver][:logroll_period]` -  (default: "3600000")
  - hbase.regionserver.logroll.period (default 3600000) -- Period at which we will roll the
    commit log regardless of how many edits it has.
* `[:hbase][:regionserver][:split_check_period]` -  (default: "20000")
  - hbase.regionserver.thread.splitcompactcheckfrequency (default 20000) -- How often a
    region server runs the split/compaction check.
* `[:hbase][:regionserver][:worker_period]` -  (default: "10000")
  - hbase.server.thread.wakefrequency (default 10_000) -- Time to sleep in between searches
    for work (in milliseconds).  Used as sleep interval by service threads such as log roller.
* `[:hbase][:regionserver][:balancer_period]` -  (default: "300000")
  - hbase.balancer.period (default 300000) -- Period at which the region balancer runs in
    the Master.
* `[:hbase][:regionserver][:balancer_slop]` -  (default: "0")
  - hbase.regions.slop (default 0) -- Rebalance if any regionserver has more than
    average + (average * slop) regions
* `[:hbase][:regionserver][:max_filesize]` -  (default: "268435456")
  - hbase.hregion.max.filesize (default 268435456) -- Maximum HStoreFile size. If any one of
    a column families' HStoreFiles has grown to exceed this value, the hosting HRegion is
    split in two.
* `[:hbase][:regionserver][:hfile_block_size]` -  (default: "65536")
  - hbase.mapreduce.hfileoutputformat.blocksize (default 65536) -- The mapreduce
    HFileOutputFormat writes storefiles/hfiles.  This is the minimum hfile blocksize to
    emit.  Usually in hbase, writing hfiles, the blocksize is gotten from the table schema
    (HColumnDescriptor) but in the mapreduce outputformat context, we don't have access to
    the schema so get blocksize from Configuation.  The smaller you make the blocksize,
    the bigger your index and the less you fetch on a random-access.  Set the blocksize
    down if you have small cells and want faster random-access of individual cells.
* `[:hbase][:regionserver][:required_codecs]` - 
  - hbase.regionserver.codecs (default "") -- To have a RegionServer test a set of
    codecs and fail-to-start if any code is missing or misinstalled, add the
    configuration hbase.regionserver.codecs to your hbase-site.xml with a value of
    codecs to test on startup. For example if the hbase.regionserver.codecs value
    is "lzo,gz" and if lzo is not present or improperly installed, the misconfigured
    RegionServer will fail to start.
* `[:hbase][:regionserver][:block_cache_size]` -  (default: "0.2")
  - hfile.block.cache.size (default 0.2) -- Percentage of maximum heap (-Xmx setting) to
    allocate to block cache used by HFile/StoreFile. Default of 0.2 means allocate 20%.
    Set to 0 to disable.
* `[:hbase][:regionserver][:hash_type]` -  (default: "murmur")
  - hbase.hash.type (default murmur) -- The hashing algorithm for use in HashFunction. Two
    values are supported now: murmur (MurmurHash) and jenkins (JenkinsHash).  Used by
    bloom filters.
* `[:hbase][:stargate][:run_state]`   -  (default: "start")
* `[:hbase][:stargate][:port]`        -  (default: "8080")
* `[:hbase][:stargate][:jmx_dash_port]` -  (default: "10105")
* `[:hbase][:stargate][:readonly]`    - 
  - hbase.rest.readonly (default false) -- Defines the mode the REST server will be started
    in. Possible values are: false: All HTTP methods are permitted - GET/PUT/POST/DELETE.
    true: Only the GET method is permitted.
* `[:hbase][:thrift][:run_state]`     -  (default: "start")
* `[:hbase][:thrift][:jmx_dash_port]` -  (default: "10104")
* `[:hbase][:zookeeper][:jmx_dash_port]` -  (default: "10103")
* `[:hbase][:zookeeper][:peer_port]`  -  (default: "2888")
* `[:hbase][:zookeeper][:leader_port]` -  (default: "3888")
* `[:hbase][:zookeeper][:client_port]` -  (default: "2181")
* `[:hbase][:zookeeper][:session_timeout]` -  (default: "180000")
  - zookeeper.session.timeout (default 180_000) -- ZooKeeper session timeout.  HBase passes
    this to the zk quorum as suggested maximum time for a session.  See
    http://hadoop.apache.org/zookeeper/docs/current/zookeeperProgrammers.html#ch_zkSessions
    "The client sends a requested timeout, the server responds with the timeout that it
    can give the client. " In milliseconds.
* `[:hbase][:zookeeper][:znode_parent]` -  (default: "/hbase")
  - zookeeper.znode.parent (default "/hbase") -- Root ZNode for HBase in
    ZooKeeper. All of HBase's ZooKeeper files that are configured with a
    relative path will go under this node.  By default, all of HBase's ZooKeeper
    file path are configured with a relative path, so they will all go under
    this directory unless changed.
* `[:hbase][:zookeeper][:znode_rootserver]` -  (default: "root-region-server")
  - zookeeper.znode.rootserver (default root-region-server) -- Path to ZNode
    holding root region location. This is written by the master and read by
    clients and region servers. If a relative path is given, the parent folder
    will be ${zookeeper.znode.parent}. By default, this means the root location
    is stored at /hbase/root-region-server.
* `[:hbase][:zookeeper][:max_client_connections]` -  (default: "2000")
  - hbase.zookeeper.property.maxClientCnxns (default 2000) -- Limit on number of concurrent
    connections (at the socket level) that a single client, identified by IP address, may
    make to a single member of the ZooKeeper ensemble. Set high to avoid zk connection
    issues running standalone and pseudo-distributed.
* `[:hbase][:client][:write_buffer]`  -  (default: "2097152")
  - hbase.client.write.buffer (default 2097152) Default size of the HTable client write
    buffer in bytes.  A bigger buffer takes more memory -- on both the client and server
    side since server instantiates the passed write buffer to process it -- but a larger
    buffer size reduces the number of RPCs made.  For an estimate of server-side
    memory-used, evaluate
    hbase.client.write.buffer * hbase.regionserver.handler.count
* `[:hbase][:client][:pause_period_ms]` -  (default: "1000")
  - hbase.client.pause (default 1000) -- General client pause value.  Used mostly as value
    to wait before running a retry of a failed get, region lookup, etc.
* `[:hbase][:client][:retry_count]`   -  (default: "10")
  - hbase.client.retries.number (default 10) -- Maximum retries.  Used as maximum for all
    retryable operations such as fetching of the root region from root region server,
    getting a cell's value, starting a row update, etc.
* `[:hbase][:client][:scanner_prefetch_rows]` -  (default: "1")
  - hbase.client.scanner.caching (default 1) -- Number of rows that will be fetched when
    calling next on a scanner if it is not served from (local, client) memory. Higher
    caching values will enable faster scanners but will eat up more memory and some calls
    of next may take longer and longer times when the cache is empty.  Do not set this
    value such that the time between invocations is greater than the scanner timeout;
    i.e. hbase.regionserver.lease.period
* `[:hbase][:client][:max_keyvalue_size]` -  (default: "10485760")
  - hbase.client.keyvalue.maxsize (default 10485760) -- Specifies the combined maximum
    allowed size of a KeyValue instance. This is to set an upper boundary for a single
    entry saved in a storage file. Since they cannot be split it helps avoiding that a
    region cannot be split any further because the data is too large. It seems wise to set
    this to a fraction of the maximum region size. Setting it to zero or less disables the
    check.
* `[:hbase][:memstore][:flush_upper_heap_pct]` -  (default: "0.4")
  - hbase.regionserver.global.memstore.upperLimit (default 0.4) -- Maximum size of all
    memstores in a region server before new updates are blocked and flushes are
    forced. Defaults to 40% of heap
* `[:hbase][:memstore][:flush_lower_heap_pct]` -  (default: "0.35")
  - hbase.regionserver.global.memstore.lowerLimit (default 0.35) -- When memstores are being
    forced to flush to make room in memory, keep flushing until we hit this mark. Defaults
    to 35% of heap.  This value equal to hbase.regionserver.global.memstore.upperLimit
    causes the minimum possible flushing to occur when updates are blocked due to memstore
    limiting.
* `[:hbase][:memstore][:flush_size_trigger]` -  (default: "67108864")
  - hbase.hregion.memstore.flush.size (default 67108864) -- Memstore will be flushed to disk
    if size of the memstore exceeds this number of bytes.  Value is checked by a thread
    that runs every hbase.server.thread.wakefrequency.
* `[:hbase][:memstore][:preflush_trigger]` -  (default: "5242880")
  - hbase.hregion.preclose.flush.size (default 5 mb) -- If the memstores in a region are
    this size or larger when we go to close, run a "pre-flush" to clear out memstores
    before we put up the region closed flag and take the region offline.  On close, a
    flush is run under the close flag to empty memory.  During this time the region is
    offline and we are not taking on any writes.  If the memstore content is large, this
    flush could take a long time to complete.  The preflush is meant to clean out the bulk
    of the memstore before putting up the close flag and taking the region offline so the
    flush that runs under the close flag has little to do.
* `[:hbase][:memstore][:flush_stall_trigger]` -  (default: "8")
  - hbase.hregion.memstore.block.multiplier (default 2) -- Block updates if memstore has
    hbase.hregion.block.memstore time hbase.hregion.flush.size bytes.  Useful preventing
    runaway memstore during spikes in update traffic.  Without an upper-bound, memstore
    fills such that when it flushes the resultant flush files take a long time to compact
    or split, or worse, we OOME.
* `[:hbase][:memstore][:mslab_enabled]` - 
  - hbase.hregion.memstore.mslab.enabled (default false) -- Experimental: Enables the
    MemStore-Local Allocation Buffer, a feature which works to prevent heap fragmentation
    under heavy write loads. This can reduce the frequency of stop-the-world GC pauses on
    large heaps.
* `[:hbase][:compaction][:files_trigger]` -  (default: "3")
  - hbase.hstore.compactionThreshold (default 3) -- If more than this number of HStoreFiles
    in any one HStore (one HStoreFile is written per flush of memstore) then a compaction
    is run to rewrite all HStoreFiles files as one.  Larger numbers put off compaction but
    when it runs, it takes longer to complete.
* `[:hbase][:compaction][:pause_trigger]` -  (default: "7")
  - hbase.hstore.blockingStoreFiles (default 7) -- If more than this number of StoreFiles in
    any one Store (one StoreFile is written per flush of MemStore) then updates are
    blocked for this HRegion until a compaction is completed, or until
    hbase.hstore.blockingWaitTime has been exceeded.
* `[:hbase][:compaction][:pause_time]` -  (default: "90000")
  - hbase.hstore.blockingWaitTime (default 90_000) -- The time an HRegion will block updates
    for after hitting the StoreFile limit defined by hbase.hstore.blockingStoreFiles.
    After this time has elapsed, the HRegion will stop blocking updates even if a
    compaction has not been completed.  Default: 90 seconds.
* `[:hbase][:compaction][:max_combine_files]` -  (default: "10")
  - hbase.hstore.compaction.max (default 10) -- Max number of HStoreFiles to compact per
    'minor' compaction.
* `[:hbase][:compaction][:period]`    -  (default: "86400000")
  - hbase.hregion.majorcompaction (default 86400000) -- The time (in miliseconds) between
    'major' compactions of all HStoreFiles in a region.  Default: 1 day.  Set to 0 to
    disable automated major compactions.
* `[:users][:hbase][:uid]`            -  (default: "304")
* `[:tuning][:ulimit][:hbase]`        - 

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
