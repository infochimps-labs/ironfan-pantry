name        'flume_master'
description 'flume master'

run_list(*%w[
  flume
  flume::install_from_release
  flume::make_dirs
  flume::jars
  flume::plugin-hbase_sink
  role[maven]
  flume::master
  flume_integration::jruby_classpath
  flume::config_files
  flume_integration::jruby_home
])
