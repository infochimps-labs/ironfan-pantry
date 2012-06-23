name        'statsd_server'
description 'installs and launches statsd'

run_list *%w[
  nodejs::compile
  statsd
  statsd::server
  ]
