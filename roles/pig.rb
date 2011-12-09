name 'pig'
description 'Installs pig with piggybank and extra jars. References (but does not install) the HBase and Zookeeper client recipes so'

default_attributes({
    :java => { :install_flavor => 'sun' }
  })

run_list %w[
  pig
  pig::install_from_package
  pig::piggybank
  pig::integration
  zookeeper
]
