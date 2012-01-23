name        'flume_agent'
description 'flume agent'

run_list(*%w[
  flume
  flume::node
  flume::jruby_plugin
  flume::hbase_sink_plugin
])
