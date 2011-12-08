name 'jruby'
description 'Installs jruby and basic gems.'

run_list %w[
  jruby
  jruby::gems
]
