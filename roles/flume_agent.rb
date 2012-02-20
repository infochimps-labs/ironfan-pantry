name        'flume_agent'
description 'flume agent'

run_list(*%w[
  flume
  flume::agent
  flume::plugin-hbase_sink
  flume::plugin-jruby
  flume::config_files
])
