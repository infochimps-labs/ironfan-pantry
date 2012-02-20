name        'hbase_thrift'
description 'runs the hbase_thrift service'

run_list %w[
  hbase::default
  hbase::thrift
  hbase::config_files
]
