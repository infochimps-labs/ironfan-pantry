name        'mongodb_server'
description 'runs a MongoDB database server'

run_list %w[
  mongodb
]
