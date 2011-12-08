name        'cassandra_server'
description 'Part of a cassandra database'

run_list *%w[
  ntp
  cassandra
  cassandra::install_from_release
  cassandra::autoconf
  cassandra::server
  cassandra::jna_support
  ]
#  cassandra::mx4j
