name        'minidash'
description 'Runs a mini dashboard for the machine'

run_list *%w[
  minidash::server
  ]
