name        'flume_agent'
description 'flume agent'

run_list(*%w[
  flume::node
  flume::jruby_plugin
])
#  flume::hbase_sink_plugin
