name        'flume_master'
description 'flume master'

run_list(*%w[
  flume
  flume::plugin-hbase_sink
  flume::plugin-jruby
  flume::master
  flume::config_files
])
