name 'zookeeper_client'
description 'Files needed to access a zookeeper.'

run_list %w[
  zookeeper::default
  zookeeper::client
  zookeeper::config_files
]
