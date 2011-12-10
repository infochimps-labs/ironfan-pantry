#!/usr/bin/env bash

set -e  # die if a command fails

basedir=$PWD

# users
#  " # 
cookbooks="cassandra cloud_utils metachef dashpot elasticsearch firewall flume ganglia graphite hadoop_cluster hbase hive install_from jruby motd nfs nodejs package_set papertrail pig redis resque rstats statsd tuning volumes volumes_ebs zookeeper"

# for cb in $cookbooks ; do rm -f cookbooks/$cb ; done
# git commit -m "Removed symlinked cookbooks, replacing with submoduled" .

# for cb in $cookbooks ; do
#   git submodule add https://github.com/infochimps-cookbooks/$cb.git cookbooks/$cb
# done

for cb in $cookbooks ; do
  cd $basedir/cookbooks/$cb

  echo -e "\n==\n== $cb \n==\n"
    
  git add . ; git ci -m "cluster_chef the cookbook is now known as 'metachef'" . || true
  
  git remote add infochimps-cookbooks git@github.com:infochimps-cookbooks/$cb.git || true
  # git co -b foo
  # git co master
  # git merge foo
  # git branch -d foo
  git pull infochimps-cookbooks master
  git push infochimps-cookbooks master
  git fetch origin
done































