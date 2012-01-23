name        'hbase_thrift'
description 'runs the hbase_thrift service'

run_list %w[
  hbase::thrift
]
