name        'flume_master'
description 'flume master'

run_list(*%w[
  flume
  flume::install_from_package
  flume::make_dirs
  flume::jars
  role[maven]
  flume::plugin-hbase_sink

  flume::master

  flume_integration::default
  flume_integration::jruby_classpath
  flume::config_files
  flume_integration::jruby_home
])
