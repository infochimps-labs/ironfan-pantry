name        'dashboard'
description 'Runs a mini dashboard for the machine'

run_list *%w[
  dashpot::server
  ]
