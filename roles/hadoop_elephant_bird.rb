name 'hadoop_elephant_bird'
description 'Installs hadoop_elephant_bird.'

run_list %w[
  hadoop_cluster::elephant_bird
]
