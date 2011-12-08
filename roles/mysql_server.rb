name        'mysql_server'
description 'runs a MySQL database server'

run_list %w[
  mysql
]
