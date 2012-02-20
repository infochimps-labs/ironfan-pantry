name        'cassandra_client'
description 'Part of a cassandra database'

run_list *%w[
  ntp
  cassandra::default
  cassandra::install_from_release
  cassandra::bintools

  cassandra::config_from_data_bag
  cassandra::client

  cassandra::config_files
  ]
