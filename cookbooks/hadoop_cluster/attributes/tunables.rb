
#
# Hadoop Performance settings
#
tunables = Mash.new

# Helpers
megabyte = (1024 * 1024)

# HDFS Block size. Too large, and you'll waste space (blocks take this size on
# disk no matter their contents). Too small, and you'll have overprovisioned
# mapper RAM, will increase the memory load on your namenode, and will have many
# small map tasks.
#
# See machine-based overrides below; we assign this value by working the mapper
# ram back through the spill buffer size and a safety factor
#
default[:hadoop][:hdfs_block_size] = (128 * megabyte)

# Block size for S3 operations. Defaults to :hdfs_block_size if unset.
#
default[:hadoop][:s3_block_size] = nil

# How often is each block replicated?  Each replica costs a multiple of disk
# space, but lets you accomodate datanode outages and more importantly lets the
# jobtracker assign machine-local map tasks. It's somewhat heretical, but for
# ebs-backed clusters and non-production work you can turn this down to 2 or
# even 1 -- you'll save a lot of disk space, but rely on EBS volumes' own
# redundancy and pay a penalty in non-local map tasks.
#
default[:hadoop][:dfs_replication] =  3

#
# Usually left at the default (0) on the cluster and adjusted for jobs. If
# you're seeing issues with s3:// turning 1TB files into 30_000+ map tasks,
#
default[:hadoop][:min_split_size]  = 0

# Settings that control thread pool size for server network connections.
#
# These values are reasonable for clusters up to a few dozen nodes. I don't have
# good guidelines for setting these, other than a) too low is catastrophic but
# too high is merely wasteful, b) increase them as the square root of your
# cluster size. The config files also increase the datanode max xcievers count,
# which should AFAIK always be bumped up.
#
default[:hadoop][:namenode   ][:handler_count]       = 40
default[:hadoop][:jobtracker ][:handler_count]       = 40
default[:hadoop][:datanode   ][:handler_count]       =  8
default[:hadoop][:tasktracker][:http_threads ]       = 32

# Number of files the reducer will read in parallel during the copy (shuffle)
# phase, and the threshold triggering the last stage of the shuffle
# (`mapred.reduce.parallel.copies`). This is an important setting but one you
# should not mess with until you have tuned the hell out of everything else.
#
# A reducer gets one file from every mapper, which it must merge sort in passes
# until there are fewer than `:reducer_parallel_copies` merged files. At that
# point, it does not need to perform the final merge-sort pass: it can stream
# directly from each file lickety-split and do the merge on the fly. A higher
# number costs more memory but can lead to fewer merge passes.
#
# The hadoop default is 5; we have increased it to 10.
#
default[:hadoop][:reducer_parallel_copies    ]       = 10

# The memory used to store map outputs during shuffle is given by
#
#   (shuffle_heap_frac * [reduce_heap_mb, 2GB].min)
#
# If you have more than 2GB of reducer heap size, consider increasing this
# value.  It only applies during the shuffle, and so does not compete with your
# reducer for heap space.
#
default[:hadoop][:shuffle_heap_frac]                 = 0.70

# The memory used to store map outputs during reduce is given by
#
#   (reduce_heap_frac * [reduce_heap_mb, 2GB].min)
#
# These buffers compete with your reducer code for heap space; however, many
# reducers simply stream data through and have no real memory burden once the
# sort/group is complete. If that is the case, or if your reducer heap size is
# well in excess of 2GB, consider adjusting this value.  Tradeoffs -- Too high:
# crash on excess java heap. Too low: modest performance hit on reduce
#
default[:hadoop][:reduce_heap_frac]                  = 0.00

# If `mapred.compress.map.output` is true, data is transparently compressed then
# decompressed during transport from mapper to reducer.  This is completely
# transparent to your jobs, and if there are no reducers, this setting is not
# applied. There's a modest CPU cost, but as midflight data often sees
# compression ratios of 5:1 or better, the typical result is dramatically faster
# transfer. Leave this `'true'` and override on a per-job basis in the rare case
# it's unhelpful.
#
default[:hadoop][:compress_mapout      ]             = 'true'

# `mapred.map.output.compression.codec`: the default is
# `'org.apache.hadoop.io.compress.DefaultCodec'`, but almost all jobs are
# improved by setting this to `'org.apache.hadoop.io.compress.SnappyCodec'`
#
default[:hadoop][:compress_mapout_codec]             = 'org.apache.hadoop.io.compress.SnappyCodec'

# Compress the job output (`mapred.output.compress`). The same benefits as
# `:compress_mapout`, but also saves significant disk space. The downside is
# that the compression is not transparent: `hadoop fs -cat` outputs the
# compressed data, which is a minor pain when doing exploratory analysis.
#
# You'd like best to use `snappy` compression -- it has the best CPU/compression
# factor balance by far -- but the toolset for working with it is not
# mature. LZO is splittable -- a big win -- but you have to a) install it
# separately, and b) run a separate indexing pass on your data to make it
# splittable.
#
# If you're willing to invest in integrating it into your workflow, LZO is
# probably the best right now. Otherwise, use Gzip and keep your output block
# sizes manageable.
#
# In practice, we leave this set at `'false'` in the site configuration, and
# have production jobs explicitly request gzip- or snappy-compressed output. (We
# find those are always superior to `.bz2` or `default` codecs.)
#
default[:hadoop][:compress_output      ]             = 'false'

# Leave this set to `'BLOCK'` (`mapred.output.compression.type`)
#
default[:hadoop][:compress_output_type ]             = 'BLOCK'

# Codec to use for job output (`mapred.output.compression.codec`). Recommend
# `...SnappyCodec`, `....GzipCodec` or lzo (see lzo cookbook)
#
default[:hadoop][:compress_output_codec]             = 'org.apache.hadoop.io.compress.DefaultCodec'

# uses /etc/default/hadoop-0.20 to set the hadoop daemon's java_heap_size_max
#
# NOTE: these have *NOTHING* to do with the heap assigned to child processes.
# Don't be one of those noobs that sets a 7GB tasktracker heap size ("But this
# one goes to ELEVEN!").
#
# These datanode and tasktracker are easy to set: just watch the nodes in action

# Namenode Java Heap size. Increase this if you have a lot of objects on your
# HDFS. A first guess: 1GB base and 1GB more per million objects.  The Secondary
# Namenode must have the same value as the Namenode, so this is used for both.
default[:hadoop][:namenode    ][:java_heap_size_max] = 1000

# Jobtracker Java Heap Size. Size this based on the largest jobs you'll
# run. Empirically 3 GB of heap will get you jobs a few thousand tasks.
# Default 1000 MB.
default[:hadoop][:jobtracker  ][:java_heap_size_max] = 1000

# Datanode Java Heap Size. Increase if each node manages a large number of blocks.
# Set this by observation: its value is fairly stable and not much is needed.
# Overridden in the autotuner (below)
default[:hadoop][:datanode    ][:java_heap_size_max] =  384

# Tasktracker Java Heap Size. Set this by observation: its value is fairly
# stable. May be overridden in the autotuner (below)
#
# Note: this is *not* the amount of RAM given to the mapper and reducer
# child processes -- see :map_heap_mb and :reduce_heap_mb below.
default[:hadoop][:tasktracker ][:java_heap_size_max] =  384

# Set to true to have Hadoop daemon JVMs write verbose logs about garbage
# collection activity. To those whom fate has led to the moment of poring
# through these, my thoughts and best wishes be with you.
#
default[:hadoop][:java_gc_log]                       = false
default[:hadoop][:task_profile]                      = false

# Rate at which datanodes exchange blocks in a rebalancing operation. If you run
# an elastic cluster, increase this value to more like 50_000_000 -- jobs will
# run more slowly while the cluster rebalances, but elasticity makes usage more
# efficient overall. In bytes per second; 1MB/s by default
default[:hadoop][:balancer][:max_bandwidth]          = 1 * megabyte

# how long to keep jobtracker logs around. We increase this from 24 hours to 240
# (ten days). Too high will have an impact on jobtracker heap; too low will have
# an impact on data scientist productivity. Jobs are discarded when either threshold of
# log_retention_hours or log_retention_count is hit.
default[:hadoop][:log_retention_hours ]              = 240

# how many jobs to keep in memory. If you're doing exploratory analytics (lots
# and lots of small jobs), bump this up to keep more job statuses around at a
# small cost of jobtracker heap. Jobs are discarded when either threshold of
# log_retention_hours or log_retention_count is hit.
default[:hadoop][:log_retention_count ]              = 100

# enable job recovery upon jobtracker restart
default[:hadoop][:jobtracker][:recover]              = false

# define a rack topology? if false (default), all nodes are in the same 'rack'.
#
# This is nice for a throwaway data science cluster -- it lets you work off an
# HDFS (much nicer than S3) while having up *and* down elasticity -- but please
# read recipes/fake_topology.rb before using.
#
# The default fake_rack_size of 4 is nice for a 5-15-25 cluster
#
# *  1 master in 'lo', running a datanode but no tasktracker
# *  4 workers in 'lo'
# * 10 workers that will be assigned to 'hi'
# * 10 tasktracker-only machines with no datanodes
#
# You'll normally run 5 machines (1 master 4 workers); burst on 10 full-fledged
# workers to get a 15-machine cluster; burst the 10 tasktracker-only machines
# for even more compute (at the cost of non-local map tasks); and be able to
# casually downsize the cluster when your job completes.
#
default[:hadoop][:define_topology]                   = false
default[:hadoop][:fake_rack_size]                    = 5

set_hadoop_tunables!() # library/hadoop_cluster.rb
