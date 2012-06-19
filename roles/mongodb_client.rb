name        'mongodb_client'
description 'runs a MongoDB database client'

run_list %w[
  mongodb::default
  mongodb::install_from_release
]
