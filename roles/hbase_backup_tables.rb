name        'hbase_backup_tables'
description 'runs the hbase table backup service'

run_list %w[
  hbase::backup_tables
]
