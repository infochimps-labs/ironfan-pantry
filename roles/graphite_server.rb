name        'graphite_server'
description 'installs graphite and launches its web services'

run_list *%w[
  python
  graphite::default
  graphite::install_from_release
  graphite::whisper
  graphite::carbon
  graphite::dashboard
  graphite::foreman_runner
  graphite::config_files
  ]
