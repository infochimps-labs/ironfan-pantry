name        'flume_master'
description 'flume master'

run_list(*%w[
  flume	
  flume::jars
  flume::plugin-hbase_sink
  flume::plugin-ics_helpers
  flume::master
  flume_integration::jruby_classpath
  flume::config_files
  flume_integration::jruby_home
])
