name        'iron_cuke'
description 'Validates a machine against its announced contract'

run_list *%w[
  iron_cuke
  iron_cuke::judge
  ]
