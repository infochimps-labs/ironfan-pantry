name        'hadoop'
description 'applies to all nodes in the hadoop cluster'

run_list *%w[
  hadoop_cluster
  hadoop_cluster::add_cloudera_repo
  hadoop_cluster::simple_dashboard
  ]

default_attributes({
    :java => { :install_flavor => 'sun' }, # Must use sun java with hadoop
  })
