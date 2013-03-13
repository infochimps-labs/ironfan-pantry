# -*- coding: utf-8 -*-

# ===========================================================================
#
# This file describes the salient settings for taking an elasticsearch cluster
# to production status. The documentary notes are largely cribbed from the
# elasticsearch documentation; the recommendations and commentary are from
# Infochimps' hard-earned experience. This rest of this cookbook's config files
# include only the settings that should be considered (and, sometimes, even
# adjusted) for a production install. This file -- which is just documentation
# at the moment -- goes on to include the full list of tuning knobs that are
# likely to have a detectable effect on production performance or stability.
#
# Now is the time that I urge you: don't be an asshole and run off and twiddle
# all fifty knobs listed below at the same time. Our customers' production
# clusters typically have no more than 6-10 overrides of the default
# values. It's only when you have dozen or dozens of machines serving terabytes
# of hot data that optimizing tcp transport parameters gives any reasonable
# return on investment. Of course, the way we figured out all these parameters
# was by being that asshole who twiddled all the knobs, so if you're reading
# this and I can't talk you out of it and you're anything less than thrilled
# with your current employ please send your resume to jobs@infochimps.com
#
#

# **When**:
#
# * rough-cut: Settings that coarsely size the system to the machine it's on;
#   every high-value install should consider this setting. (example: heap size)
#
# * production: Once you have a working cluster, understand the load spectrum of
#   your cluster (read- or write-heavy, etc), and have everything in place to
#   test it under heavy load, these settings trade off concerns to suit the
#   cluster to your specific application (example: index buffer size)
#
# * post-production: Once you have a system that works in production, with
#   well-quantified usage, and you'd like it to work better, these settings help
#   fine-tune and optimize performance -- but may have complex side effects or
#   markedly hurt performance if chosen foolishly. (example: TCP nagle/no-delay;
#   gateway concurrent streams)

# **Type**:
#
# * `time`: `10s`, `30m`
# * `size`: '15m', etc

# ===========================================================================
#
# ## Logging and Monitoring
#

# [Slow Log](http://elasticsearch.org/guide/reference/index-modules/slowlog.html)
# notes query and fetch requests that take a long time, invaluable for improving
# your app's performance.
#
# By default, none are enabled (set to -1). Levels (warn, info, debug, trace)
# allow to control under which logging level the log will be logged. Not all are
# required to be configured (for example, only warn threshold can be set). The
# benefit of several levels is the ability to quickly “grep” for specific
# thresholds breached.
#
# The logging is done on the shard level scope, meaning the execution of a
# search request within a specific shard. It does not encompass the whole search
# request, which can be broadcast to several shards in order to execute. Some of
# the benefits of shard level logging is the association of the actual execution
# on the specific machine, compared with request level.
#
# The log file itself is configured in logging.yml
#
# index.search.slowlog.threshold.query.warn: 10s
# index.search.slowlog.threshold.query.info: 5s
# index.search.slowlog.threshold.query.debug: 2s
# index.search.slowlog.threshold.query.trace: 500ms
# index.search.slowlog.threshold.fetch.warn: 1s
# index.search.slowlog.threshold.fetch.info: 800ms
# index.search.slowlog.threshold.fetch.debug: 500ms
# index.search.slowlog.threshold.fetch.trace: 200ms

# Elasticsearch can expose a
# [JMX](http://onjava.com/pub/a/onjava/2001/02/01/jmx.html) endpoint, sharing
# data on both node level information and instantiated index & shard allocation
# per-node.
#
# Enable the RMI connector by setting jmx.create_connector to true. It comes
# with its own overhead, make sure you really need it -- with that said, JMX is
# invaluable for monitoring and diagnosing production use; we consider it
# indispensable.
#
# `jmx.port` -- port range for JMX RMI connector. default: 9400-9500.
#
# In an EC2 environment, you must also ensure JMX is accessible from outside world:
#
# * `com.sun.management.jmxremote.ssl=false`
# * `com.sun.management.jmxremote.authenticate=false`
# * `java.rmi.server.hostname=<%= @elasticsearch[:jmx_dash_addr] %>`

# ===========================================================================
#
# ## Client support
#

# `http.max_content_length` Max content size of an HTTP request. default:
# 100mb. recommended: think about the largest request you'd like to
# be able to do, and set it to that. impact: high; risk: low; when: production.

# `http.compression_level` -- Support for compression when possible (with
# Accept-Encoding). default: false; recommended: trades CPU for network
# throughput. impact: moderate; risk: low; when: post-production

#
# The thrift transport module exposes the elasticsearch REST interface over
# thrift, which typically provides better performance than http. Thrift defines
# both the wire protocol and the transport, making it simpler (though it's
# lacking on docs…). You must install the
# [transport-thrift](https://github.com/elasticsearch/elasticsearch-transport-thrift)
# plugin.
#
# `thrift.frame` -- enable framed transport for thrift. type: `size`; default:
# -1 (no framing). Every production install should enable framed transport by
# setting a higher value (eg 15mb), assuming your client supports it; if not,
# fix your client.
#
#

# ===========================================================================
#
# ## Optimizing Writes
#

# Tradeoffs of write vs read == num segments
# http://www.elasticsearch.org/guide/reference/index-modules/merge.html
#
# Balance disk access -- all the index.merge.policy.*

#
# [Indexing Buffer](http://www.elasticsearch.org/guide/reference/modules/indices.html)
#

# `indices.memory.index_buffer_size` -- The indexing buffer setting allows to
# control how much memory will be allocated for the indexing process. It is a
# global setting that bubbles down to all the different shards allocated on a
# specific node.
#
# The indices.memory.index_buffer_size accepts either a percentage or a byte
# size value. It defaults to 10%, meaning that 10% of the total memory allocated
# to a node will be used as the indexing buffer size. This amount is then
# divided between all the different shards. Also, if percentage is used, allow
# to set min_index_buffer_size (defaults to 48mb) and max_index_buffer_size
# which by default is unbounded.
#
# * default: 10%
# * production recommended: for hadoop use, you want this large. For
#   a read-heavy system the default is probably reasonable.
# * impact: high; risk: high; when: production.
#
#
# `network.tcp.no_delay` -- when true, packets are sent out immediately rather
# than buffering into full-sized packets (that is, it disables the "Nagle
# algorithm")
#
# * default: true
# * production recommended: false for throughput; true for latency.
# * low impact, low risk, expert-level.
#

# Deletion and [TTL](http://www.elasticsearch.org/guide/reference/mapping/ttl-field.html)
#
# Expired documents will be automatically deleted regularly. You can dynamically
# set the indices.ttl.interval to fit your needs. The default value is 60s.
#
# The deletion orders are processed by bulk. You can set indices.ttl.bulk_size
# to fit your needs. The default value is 10000.
#
# Note that the expiration procedure handle versioning properly so if a document
# is updated between the collection of documents to expire and the delete order,
# the document won’t be deleted.

# ===========================================================================
#
# ## Optimizing Reads
#

# Caching
#
# cache.memory.direct   Should the memory be allocated outside of the JVM heap. Defaults to true.
# cache.memory.small_buffer_size        The small buffer size, defaults to 1kb.
# cache.memory.large_buffer_size        The large buffer size, defaults to 1mb.
# cache.memory.small_cache_size The small buffer cache size, defaults to 10mb.
# cache.memory.large_cache_size The large buffer cache size, defaults to 500mb.

# From the client side, you can help make caching legible by setting the
# `"_cache"` element on filter queries. You may also set `"_cache_key"`, used as
# the caching key for that filter -- handy when using very large filters (like a
# terms filter with many elements in it).

# index.refresh_interval        The async refresh interval of a shard.
# index.translog.flush_threshold_ops    When to flush based on operations.
# index.translog.flush_threshold_size   When to flush based on translog (bytes) size.
# index.translog.flush_threshold_period When to flush based on a period of not flushing.
# index.translog.disable_flush  Disables flushing. Note, should be set for a short interval and then enabled.
#

# ===========================================================================
#
# ## Recovery:
#

# In many cases, the actual cluster meta data should only be recovered after
# specific nodes have started in the cluster, or a timeout has passed. This is
# handy when restarting the cluster, and each node local index storage still
# exists to be reused and not recovered from the gateway (which reduces the time
# it takes to recover from the gateway).
#
# The `gateway.recover_after_node`s setting (which accepts a number) controls
# after how many nodes within the cluster recovery will start. The
# `gateway.recover_after_time` setting (which accepts a time value) sets the
# time to wait till recovery happens once the nodes are met.
#
# The gateway.expected_nodes allows to set how many nodes are expected to be in
# the cluster, and once met, the `recover_after_time` is ignored and recovery
# starts.
#
# Set the expected nodes to your cluster size. For small clusters (four or
# fewer) nodes, set recover_after_nodes equal to cluster size; for larger
# clusters, set it slightly smaller -- say '4' on a 5-node cluster, '12' on a
# 15-node cluster. This means that you can still bring the cluster up with only
# recover_after_nodes available, accepting that you may waste some bandwidth
# passing shards around if there are stragglers.

# `gateway.expected_nodes`
# `gateway.recover_after_nodes`
# `gateway.recover_after_time`

# c.r.a.cluster_concurrent_rebalance -- Number of concurrent rebalancing shards
# allowed cluster wide. default: 2.

# c.r.a.node_initial_primaries_recoveries -- Number of initial recoveries of
# primaries allowed per node. If local gateway is used (which is fast) or S3
# gateway _from AWS machines_ (which has a big parallel pipe) we can handle more
# of those per node without creating load.
#
# `c.r.a.node_concurrent_recoveries` -- Number of concurrent recoveries are
# allowed to happen on a node. default: 2.
#
# `indices.recovery.concurrent_streams` -- Number of streams to open (on a node
# level) to recover a shard from a peer shard. default: 3.
#
# `cluster.routing.allocation.awareness.*` -- Cluster allocation awareness
# places shards and replicas intelligently as guided by attributes you associate
# with each node.

#
# curl -XPUT 'localhost:9200/_cluster/settings?pretty=true' -d '{ "persistent": {
#   "cluster.routing.allocation": {
#     "allow_rebalance": "always",
#     "cluster_concurrent_rebalance": 20, "node_concurrent_recoveries": 20, "node_initial_primaries_recoveres": 30  },
#    "indices.recovery": { "concurrent_streams": 3, "compress": true } } }'
#


# ===========================================================================
#
# ## Snapshots:
#

# The gateway module allows one to store the state of the cluster meta data
# across full cluster restarts. The cluster meta data mainly holds all the
# indices created with their respective (index level) settings and explicit type
# mappings.
#
# Each time the cluster meta data changes (for example, when an index is added
# or deleted), those changes will be persisted using the gateway. When the
# cluster first starts up, the state will be read from the gateway and applied.
#
# The gateway set on the node level will automatically control the index gateway
# that will be used. For example, if the fs gateway is used, then automatically,
# each index created on the node will also use its own respective index level fs
# gateway. In this case, if an index should not persist its state, it should be
# explicitly set to none (which is the only other value it can be set to).
#
# recommended:
#

# `gateway.*.concurrent_streams`

# `gateway.s3.chunk_size` -- Big files are broken down into chunks (to overcome
# AWS 5g limit and use concurrent snapshotting). default: "100m"; impact: low;
# risk: low; when: expert-level.
#
# `gateway.s3.concurrent_streams` -- throttle the number of streams (per node)
# opened against the shared gateway performing the snapshot operation. default:
# 5; impact: low; risk: high; when: expert-level.

# ===========================================================================
#
# ## Network Transport
#

#
# [HTTP](http://www.elasticsearch.org/guide/reference/modules/http.html)
# [Transport](http://www.elasticsearch.org/guide/reference/modules/transport.html)

# The transport module is used for internal communication between nodes within
# the cluster. Each call that goes from one node to the other uses the transport
# module (for example, an HTTP GET request processed by one node but that should
# actually be processed by another node that holds the data, will use the
# transport channel for that internal conversation before returning the answer
# over HTTP). The transport mechanism is completely asynchronous in nature,
# meaning that there is no blocking thread waiting for a response.
#
#
# `transport.tcp.connect_timeout` -- The socket connect timeout setting (in time
# setting format). default: 2s. production recommended: slightly higher if you
# have a bursty load on an uncertain network. Adjust this only after observing
# client timeouts, but keep it in the back of your mind. Probably should be
# increased for Hadoop usage. Basically, think about why this time would be
# exceeded: if you have a steady-load low-latency system, conns would only time
# out if something is wrong, and increasing this will hurt stability. If you
# have a bursty system, you want to be gracious to stragglers, and increasing
# this will help stability.

# `transport.tcp.compress` -- Set to true to enable compression (LZF) between
# all nodes. Defaults to false.  Trades CPU for bandwidth; may be reasonable in
# a high-throughput cluster in a fuzzy network environment (ie AWS). impact:
# medium; risk: high, when: post-production, expert-level
