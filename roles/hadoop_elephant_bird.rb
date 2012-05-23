name 'hadoop_elephant_bird'
description 'Installs hadoop_elephant_bird.'

default_attributes({
    :java => { :install_flavor => 'sun' }
  })

run_list %w[
  hadoop_cluster::elephant_bird
]
