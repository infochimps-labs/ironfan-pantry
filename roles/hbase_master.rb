name        'hbase_master'
description 'runs an hbase-master in fully-distributed mode. There should be exactly one of these per cluster.'

run_list %w[
  role[hadoop]
  zookeeper::client
  hbase::master
  hbase::dashboard
  dashpot::server
]
