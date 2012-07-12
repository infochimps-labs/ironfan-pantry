name 'hadoop_lzo'
description 'Installs hadoop_lzo.'

run_list %w[
  hadoop_cluster::lzo
]
