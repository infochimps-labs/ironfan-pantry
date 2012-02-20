name        'cassandra_client'
description 'Part of a cassandra database'

run_list *%w[
  ntp
  cassandra
  cassandra::install_from_release
  cassandra::autoconf
  cassandra::client

  cassandra::config_files
  ]
