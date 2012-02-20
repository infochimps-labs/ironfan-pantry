name        'hbase_stargate'
description 'runs the hbase_stargate service'

run_list %w[
  hbase::default
  hbase::stargate
  hbase::config_files
]
