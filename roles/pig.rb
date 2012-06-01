name 'pig'
description 'Installs pig with piggybank and extra jars. References (but does not install) the HBase and Zookeeper client recipes so'

run_list %w[
  pig
  pig::install_from_release
  pig::piggybank
  pig::integration
  zookeeper
]
