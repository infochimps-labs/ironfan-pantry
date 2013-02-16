# Default Recipe - Back up everything you. 

# HBase 
# Namenode
# Elasticsarch (todo)
# Zookeeper - Currently needs to be ran on a zookeeper node, so it's not included at this time

include_recipe "backups::namenode"
include_recipe "backups::hbase"
