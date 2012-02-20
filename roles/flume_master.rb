name        'flume_master'
description 'flume master'

run_list(*%w[
  flume
  flume::master
  flume::jruby_plugin
  flume::hbase_sink_plugin
])
