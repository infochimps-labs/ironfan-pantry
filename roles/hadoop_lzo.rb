name 'hadoop_lzo'
description 'Installs hadoop_lzo.'

default_attributes({
    :java => { :install_flavor => 'sun' }
  })

run_list %w[
  hadoop_cluster::lzo
]
