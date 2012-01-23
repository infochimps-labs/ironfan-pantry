name        'hbase_client'
description 'machine is able to act as an hbase-client.'

run_list %w[
  hbase::default
  hbase::config
]
