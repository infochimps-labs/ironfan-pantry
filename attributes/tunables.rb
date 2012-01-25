
#
# Tunables
#

default[:tuning][:ulimit]['hbase']  = { :nofile => { :both => 32768 }, :nproc => { :both => 50000 } }

default[:hbase][:master      ][:java_heap_size_max]     = "1000m"
default[:hbase][:regionserver][:java_heap_size_max]     = "2000m"
default[:hbase][:master      ][:java_heap_size_new]     = "256m"
default[:hbase][:regionserver][:java_heap_size_new]     = "256m"

# -XX:+UseParNewGC

default[:hbase][:master      ][:gc_tuning_opts]         = "-XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:+AggressiveOpts"
default[:hbase][:regionserver][:gc_tuning_opts]         = "-XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:+AggressiveOpts -XX:CMSInitiatingOccupancyFraction=88"

default[:hbase][:master      ][:gc_log_opts]            = "-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps"
default[:hbase][:regionserver][:gc_log_opts]            = "-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps"

#
# !!!NOTE!!!!
#
# The slightly-humanized names below are under review and subject to
# modification until cluster_chef v3 is released. We may change them
# until then but won't change them after
#
#

# hbase.client.write.buffer (default 2097152) Default size of the HTable client write
#   buffer in bytes.  A bigger buffer takes more memory -- on both the client and server
#   side since server instantiates the passed write buffer to process it -- but a larger
#   buffer size reduces the number of RPCs made.  For an estimate of server-side
#   memory-used, evaluate
#
#     hbase.client.write.buffer * hbase.regionserver.handler.count
#
default[:hbase][:client][:write_buffer]                 = 2097152              ## 2097152

# hbase.client.pause (default 1000) -- General client pause value.  Used mostly as value
#   to wait before running a retry of a failed get, region lookup, etc.
#
default[:hbase][:client][:pause_period_ms]              = 1000                 ## 1000

# hbase.client.retries.number (default 10) -- Maximum retries.  Used as maximum for all
#   retryable operations such as fetching of the root region from root region server,
#   getting a cell's value, starting a row update, etc.
#
default[:hbase][:client][:retry_count]                  = 10                   ## 10

# hbase.client.scanner.caching (default 1) -- Number of rows that will be fetched when
#   calling next on a scanner if it is not served from (local, client) memory. Higher
#   caching values will enable faster scanners but will eat up more memory and some calls
#   of next may take longer and longer times when the cache is empty.  Do not set this
#   value such that the time between invocations is greater than the scanner timeout;
#   i.e. hbase.regionserver.lease.period
#
default[:hbase][:client][:scanner_prefetch_rows]        = 1                    ## 1

# hbase.client.keyvalue.maxsize (default 10485760) -- Specifies the combined maximum
#   allowed size of a KeyValue instance. This is to set an upper boundary for a single
#   entry saved in a storage file. Since they cannot be split it helps avoiding that a
#   region cannot be split any further because the data is too large. It seems wise to set
#   this to a fraction of the maximum region size. Setting it to zero or less disables the
#   check.
#
default[:hbase][:client][:max_keyvalue_size]            = 10485760             ## 10485760

# hbase.regionserver.lease.period (default 60000) -- HRegion server lease period in
#   milliseconds. Default is 60 seconds. Clients must report in within this period else
#   they are considered dead.
#
default[:hbase][:regionserver][:lease_period]           = 60000                ## 60000

# hbase.regionserver.handler.count (default 10) -- Count of RPC Server instances spun up
#   on RegionServers. Same property is used by the Master for count of master handlers.
#
default[:hbase][:regionserver][:handler_count]          = 10                   ## 10

# hbase.regionserver.regionSplitLimit (default 2147483647) -- Limit for the number of
#   regions after which no more region splitting should take place. This is not a hard
#   limit for the number of regions but acts as a guideline for the regionserver to stop
#   splitting after a certain limit. Default is set to MAX_INT; i.e. do not block
#   splitting.
#
default[:hbase][:regionserver][:split_limit]            = 2_147_483_647        ## 2_147_483_647

# hbase.regionserver.msginterval (default 3000) -- Interval between messages from the
#   RegionServer to Master in milliseconds.
#
default[:hbase][:regionserver][:msg_period]             = 3_000                ## 3000

# hbase.regionserver.optionallogflushinterval (default 1000) -- Sync the HLog to the HDFS
#   after this interval if it has not accumulated enough entries to trigger a
#   sync. Default 1 second. Units: milliseconds.
#
default[:hbase][:regionserver][:log_flush_period]       = 1_000                ## 1_000

# hbase.regionserver.logroll.period (default 3600000) -- Period at which we will roll the
#   commit log regardless of how many edits it has.
#
default[:hbase][:regionserver][:logroll_period]         = 3_600_000            ## 3_600_000

# hbase.regionserver.thread.splitcompactcheckfrequency (default 20000) -- How often a
#   region server runs the split/compaction check.
#
default[:hbase][:regionserver][:split_check_period]     = 20_000               ## 20_000

# hbase.server.thread.wakefrequency (default 10_000) -- Time to sleep in between searches
#   for work (in milliseconds).  Used as sleep interval by service threads such as log roller.
#
default[:hbase][:regionserver][:worker_period]          = 10_000               ## 10_000

# hbase.balancer.period (default 300000) -- Period at which the region balancer runs in
#   the Master.
#
default[:hbase][:regionserver][:balancer_period]        = 300_000              ## 300_000

# hbase.regions.slop (default 0) -- Rebalance if any regionserver has more than
#
#   average + (average * slop) regions
#
default[:hbase][:regionserver][:balancer_slop]          = 0                    ## 0

# hbase.regionserver.global.memstore.upperLimit (default 0.4) -- Maximum size of all
#   memstores in a region server before new updates are blocked and flushes are
#   forced. Defaults to 40% of heap
#
default[:hbase][:memstore][:flush_upper_heap_pct]       = 0.4                  ## 0.4

# hbase.regionserver.global.memstore.lowerLimit (default 0.35) -- When memstores are being
#   forced to flush to make room in memory, keep flushing until we hit this mark. Defaults
#   to 35% of heap.  This value equal to hbase.regionserver.global.memstore.upperLimit
#   causes the minimum possible flushing to occur when updates are blocked due to memstore
#   limiting.
#
default[:hbase][:memstore][:flush_lower_heap_pct]       = 0.35                 ## 0.35

# hbase.hregion.memstore.flush.size (default 67108864) -- Memstore will be flushed to disk
#   if size of the memstore exceeds this number of bytes.  Value is checked by a thread
#   that runs every hbase.server.thread.wakefrequency.
#
default[:hbase][:memstore][:flush_size_trigger]         = 67_108_864           ## 67108864

# hbase.hregion.preclose.flush.size (default 5 mb) -- If the memstores in a region are
#   this size or larger when we go to close, run a "pre-flush" to clear out memstores
#   before we put up the region closed flag and take the region offline.  On close, a
#   flush is run under the close flag to empty memory.  During this time the region is
#   offline and we are not taking on any writes.  If the memstore content is large, this
#   flush could take a long time to complete.  The preflush is meant to clean out the bulk
#   of the memstore before putting up the close flag and taking the region offline so the
#   flush that runs under the close flag has little to do.
#
default[:hbase][:memstore][:preflush_trigger]           = (5 * 1024 * 1024) # (5 * 1024 * 1024)

# hbase.hregion.memstore.block.multiplier (default 2) -- Block updates if memstore has
#   hbase.hregion.block.memstore time hbase.hregion.flush.size bytes.  Useful preventing
#   runaway memstore during spikes in update traffic.  Without an upper-bound, memstore
#   fills such that when it flushes the resultant flush files take a long time to compact
#   or split, or worse, we OOME.
#
default[:hbase][:memstore][:flush_stall_trigger]        = 8                    ## 2

# hbase.hregion.memstore.mslab.enabled (default false) -- Experimental: Enables the
#   MemStore-Local Allocation Buffer, a feature which works to prevent heap fragmentation
#   under heavy write loads. This can reduce the frequency of stop-the-world GC pauses on
#   large heaps.
#
default[:hbase][:memstore][:mslab_enabled]              = false                ## false

# hbase.hregion.max.filesize (default 268435456) -- Maximum HStoreFile size. If any one of
#   a column families' HStoreFiles has grown to exceed this value, the hosting HRegion is
#   split in two.
#
default[:hbase][:regionserver][:max_filesize]           = (256 * 1024 * 1024)  ## 256 MB

# hbase.hstore.compactionThreshold (default 3) -- If more than this number of HStoreFiles
#   in any one HStore (one HStoreFile is written per flush of memstore) then a compaction
#   is run to rewrite all HStoreFiles files as one.  Larger numbers put off compaction but
#   when it runs, it takes longer to complete.
#
default[:hbase][:compaction][:files_trigger]            = 3                    ## 3

# hbase.hstore.blockingStoreFiles (default 7) -- If more than this number of StoreFiles in
#   any one Store (one StoreFile is written per flush of MemStore) then updates are
#   blocked for this HRegion until a compaction is completed, or until
#   hbase.hstore.blockingWaitTime has been exceeded.
#
default[:hbase][:compaction][:pause_trigger]            = 7                    ## 7

# hbase.hstore.blockingWaitTime (default 90_000) -- The time an HRegion will block updates
#   for after hitting the StoreFile limit defined by hbase.hstore.blockingStoreFiles.
#   After this time has elapsed, the HRegion will stop blocking updates even if a
#   compaction has not been completed.  Default: 90 seconds.
#
default[:hbase][:compaction][:pause_time]               = 90_000               ## 90000

# hbase.hstore.compaction.max (default 10) -- Max number of HStoreFiles to compact per
# 'minor' compaction.
#
default[:hbase][:compaction][:max_combine_files]        = 10                   ## 10

# hbase.hregion.majorcompaction (default 86400000) -- The time (in miliseconds) between
#   'major' compactions of all HStoreFiles in a region.  Default: 1 day.  Set to 0 to
#   disable automated major compactions.
#
default[:hbase][:compaction][:period]                   = 86_400_000           ## 86_400_000

# hbase.mapreduce.hfileoutputformat.blocksize (default 65536) -- The mapreduce
#   HFileOutputFormat writes storefiles/hfiles.  This is the minimum hfile blocksize to
#   emit.  Usually in hbase, writing hfiles, the blocksize is gotten from the table schema
#   (HColumnDescriptor) but in the mapreduce outputformat context, we don't have access to
#   the schema so get blocksize from Configuation.  The smaller you make the blocksize,
#   the bigger your index and the less you fetch on a random-access.  Set the blocksize
#   down if you have small cells and want faster random-access of individual cells.
#
default[:hbase][:regionserver][:hfile_block_size]       = 65536                ## 65536

# hbase.regionserver.codecs (default "") -- To have a RegionServer test a set of
# codecs and fail-to-start if any code is missing or misinstalled, add the
# configuration hbase.regionserver.codecs to your hbase-site.xml with a value of
# codecs to test on startup. For example if the hbase.regionserver.codecs value
# is "lzo,gz" and if lzo is not present or improperly installed, the misconfigured
# RegionServer will fail to start.
#
default[:hbase][:regionserver][:required_codecs]        = ""

# hfile.block.cache.size (default 0.2) -- Percentage of maximum heap (-Xmx setting) to
#   allocate to block cache used by HFile/StoreFile. Default of 0.2 means allocate 20%.
#   Set to 0 to disable.
#
default[:hbase][:regionserver][:block_cache_size]       = 0.2                  ## 0.2

# hbase.hash.type (default murmur) -- The hashing algorithm for use in HashFunction. Two
#   values are supported now: murmur (MurmurHash) and jenkins (JenkinsHash).  Used by
#   bloom filters.
#
default[:hbase][:regionserver][:hash_type]              = "murmur"             ## "murmur"

#
# Built-in zookeeper
#

# zookeeper.session.timeout (default 180_000) -- ZooKeeper session timeout.  HBase passes
#   this to the zk quorum as suggested maximum time for a session.  See
#   http://hadoop.apache.org/zookeeper/docs/current/zookeeperProgrammers.html#ch_zkSessions
#   "The client sends a requested timeout, the server responds with the timeout that it
#   can give the client. " In milliseconds.
#
default[:hbase][:zookeeper][:session_timeout]           = 180_000              ## 180_000

# zookeeper.znode.parent (default "/hbase") -- Root ZNode for HBase in
#   ZooKeeper. All of HBase's ZooKeeper files that are configured with a
#   relative path will go under this node.  By default, all of HBase's ZooKeeper
#   file path are configured with a relative path, so they will all go under
#   this directory unless changed.
#
default[:hbase][:zookeeper][:znode_parent]              = '/hbase'             ## "/hbase"

# zookeeper.znode.rootserver (default root-region-server) -- Path to ZNode
#   holding root region location. This is written by the master and read by
#   clients and region servers. If a relative path is given, the parent folder
#   will be ${zookeeper.znode.parent}. By default, this means the root location
#   is stored at /hbase/root-region-server.
#
default[:hbase][:zookeeper][:znode_rootserver]          = "root-region-server" ## "root-region-server"

# hbase.zookeeper.property.maxClientCnxns (default 2000) -- Limit on number of concurrent
#   connections (at the socket level) that a single client, identified by IP address, may
#   make to a single member of the ZooKeeper ensemble. Set high to avoid zk connection
#   issues running standalone and pseudo-distributed.
#
default[:hbase][:zookeeper][:max_client_connections]    = 2000                 ## 2000


# # The zookeeper.session.timeout must be a minimum of 2 times the tickTime and a maximum of 20 times the tickTime. " For large clusters or latent environments (eg EC2), set it to 6 or 9 even from its current setting of '3'.
# default[:hbase][:regionserver][:zookeeper_tick_time]  = 6 # 3

# default[:hbase][:dfs][:replication]                   = 3

# hbase.master.lease.period                           | 120000
# hbase.master.meta.thread.rescanfrequency            | 60000
# hbase.hbasemaster.maxregionopen                     |    120000
# hbase.regions.percheckin                            |    10
# hfile.min.blocksize.size                            |    65536
# zookeeper.retries                                   |    5
# zookeeper.pause                                     |    2000
# zookeeper.znode.safemode                            |    safe-mode
# hbase.zookeeper.property.tickTime                   |    3000
