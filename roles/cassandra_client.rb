name        'cassandra_client'
description 'Part of a cassandra database'

run_list *%w[
  cassandra
  cassandra::install_from_release
  cassandra::autoconf
  cassandra::client
  ]
