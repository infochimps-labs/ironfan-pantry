name        'flume_master'
description 'flume master'

run_list(*%w[
  flume	
  flume::jars
  flume::plugin-hbase_sink
  role[maven]
  flume::master
  flume_integration::jruby_classpath
  flume::config_files
  flume::plugin-ics_extensions
  flume_integration::jruby_home
])
