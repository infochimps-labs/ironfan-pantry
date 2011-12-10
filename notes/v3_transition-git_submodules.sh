
# users 

cookbooks="cassandra " # cloud_utils metachef dashpot elasticsearch firewall flume ganglia graphite hadoop_cluster hbase hive install_from jruby motd nfs nodejs package_set papertrail pig redis resque rstats statsd tuning volumes volumes_ebs zookeeper"

for cb in $cookbooks ; do

  rm cookbooks/$cb

  git submodule add https://github.com/infochimps-cookbooks/$cb.git $cb

done































