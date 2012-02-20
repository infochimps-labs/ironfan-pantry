name        'flume_master'
description 'flume master'

run_list(*%w[
  flume
  flume::master
  flume::plugin-hbase_sink
  flume::plugin-jruby
  flume::config_files
])
