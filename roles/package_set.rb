name        'package_set'
description 'Installs packages according to node attributes; set overrides here'

run_list %w[
  package_set
]

default_attributes({
    :package_set => {
      :install => %w[ base dev sysadmin ],
    }
  })
