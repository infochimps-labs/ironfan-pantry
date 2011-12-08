name        'ganglia_master'
description 'Aggregate Ganglia metrics'

run_list *%w[
  ganglia
  ganglia::server
  ]
