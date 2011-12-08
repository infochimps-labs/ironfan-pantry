name        'tuning'
description 'Applies OS tuning parameters (ulimits and such) as advised by other packages'

run_list %w[
  tuning::default
]
