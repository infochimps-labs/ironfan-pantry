name        'hadoop'
description 'applies to all nodes in the hadoop cluster'

run_list *%w[
  hadoop_cluster
  hadoop_cluster::minidash
  ]
