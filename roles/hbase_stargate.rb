name        'hbase_stargate'
description 'runs the hbase_stargate service'

run_list %w[
  hbase::stargate
]
