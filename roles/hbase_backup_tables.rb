name        'hbase_backup_tables'
description 'runs the hbase table backup service'

run_list %w[
  hbase::default
  hbase::backup_tables
  hbase::config_files
]
