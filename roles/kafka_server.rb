name        'kafka_server'
description 'kafka server'

run_list(*%w[
  java::openjdk
  kafka
  kafka::users
  kafka::directories
  kafka::install_from_release
  kafka::server
])
