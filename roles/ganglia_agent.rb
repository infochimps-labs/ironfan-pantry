name        'ganglia_agent'
description 'Send Ganglia metrics'

run_list *%w[
  ganglia
  ganglia::monitor
  ]
