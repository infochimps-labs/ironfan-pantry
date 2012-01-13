name        'nfs_server'
description 'exports an nfs directory'

run_list *%w[
  nfs
  nfs::server
]
