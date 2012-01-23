name        'hbase_master'
description 'runs an hbase-master in fully-distributed mode. You may launch multiple masters; only one will act, unless another goes down.'

run_list %w[
  role[hadoop]
  zookeeper::client
  hbase::master
  hbase::dashboard
  dashpot::server
]
