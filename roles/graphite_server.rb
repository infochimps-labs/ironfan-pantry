name        'graphite_server'
description 'installs graphite and launches its web services'

run_list *%w[
  graphite::default
  graphite::carbon
  graphite::dashboard
  graphite::whisper
  ]
