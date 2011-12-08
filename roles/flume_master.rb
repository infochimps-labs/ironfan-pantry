name        'flume_master'
description 'flume master'

run_list(*%w[
  flume
  flume::master
  flume::node
  flume::jruby_plugin
])
