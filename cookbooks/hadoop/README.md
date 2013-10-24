# hadoop chef cookbook

Hadoop: distributed massive-scale data processing framework. Store and analyze terabyte-scale datasets with ease

* Ironfan tools: [http://github.com/infochimps-labs/ironfan](http://github.com/infochimps-labs/ironfan)
* Homebase (shows cookbook in use): [http://github.com/infochimps-labs/ironfan-homebase](http://github.com/infochimps-labs/ironfan-homebase)

## Overview

The hadoop cookbook lets you spin up hadoop clusters of arbitrary size, makes it easy to configure and tune them, and opens up powerful new ways to reduce your compute bill. 

This cookbook installs Apache hadoop using the [Cloudera hadoop distribution (CDH)](http://archive.cloudera.com/docs/), and it plays well with the infochimps cookbooks for HBase, ElasticSearch, Zookeeper and Zabbix.

### The Cookbook's Historical Context

The 'hadoop' cookbook is a refactor of the earlier 'hadoop_cluster' cookbook to support Cloudera releases greater than 3 (e.g. CDH4 and above).
This cookbook will replace hadoop_cluster in the not-too-distant future.  At this moment it's fairly spartan:

* Cloudera Hadoop 4
* MR1 only
* Traditional namenode only (HA namenode will come later)
* Core daemons only (supporting components, e.g. Pig, will come later)

### Conflicting Roles/Recipes

A few recipes which are common in ironfan deployments have to be factored out
of your cluster definition to use this cookbook:

* hadoop_cluster::add_cloudera_repo
* repo::apt_repository

...which are pulled in by these common roles:

* systemwide
* the_village
* zookeeper_client

Specifically, these two recipes add an apt repository, hard-coded to CDH3, called
'cloudera', which clobbers the CDH4 apt repository installed by this cookbook.  If
the chef-client run fails at an apt step, check whether /etc/apt/sources.list.d/cloudera.list
reflects CDH3 instead of the desired CDH4.

To factor out the offending roles, replace the role in your cluster definition with its 
constituent recipes, omitting the two CDH3-including recipes above.  Example: replace
"role :zookeeper_client" with "recipe 'zookeeper::client'".

### Usage

The following, when placed inside of a facet block, will define
an all-in-one Hadoop cluster.  (For illustration only, of course you
want to split the responsibilities onto different nodes for real use).

```
    facet_role.override_attributes({
      :hadoop => {
        :namenode => { :discover_in => cluster_name },
        :secondarynn => { :discover_in => cluster_name },
        :datanode => { :discover_in => cluster_name },
        :jobtracker => { :discover_in => cluster_name },
      },
    })

    recipe                'hadoop::default'
    recipe                'hadoop::namenode'
    recipe                'hadoop::secondarynn'
    recipe                'hadoop::datanode'
    recipe                'hadoop::jobtracker'
    recipe                'hadoop::tasktracker'
    recipe                'hadoop::config_files', :last
```

Note that homebases have no roles defined which reference this cookbook.  The cookbook
is still maturing, and also it's good to not let version-dependent features
(like the CDH4 apt repo) bleed out into roles which are version-unaware.

### Initial Cluster Setup

These cluster initialization steps are helpful for preventing race 
conditions dealing with resizing EBS volumes. Follow them to 
painlessly set up Hadoop clusters.

#### Starting the Master

  1. Set the :run_state to :stop for all hadoop daemons in the
     master in the cluster definition.
  2. Launch the master.
  3. Rerun chef-client and ensure the EBS volumes have resized.
  4. Run "/etc/hadoop/conf/bootstrap\_hadoop\_namenode" as root.
  5. Set the :run_state to :start as desired for all appropriate
     Hadoop daemons and run a "knife cluster sync."
  6. Rerun chef-client.

#### Launching the First Worker

  1. Set the :run_state to :stop for all hadoop daemons in the
     worker in the cluster definition.
  2. Launch the first worker.
  3. Rerun chef-client and ensure the EBS volumes have resized.

#### Launching the Rest of the Workers    
   
  1. Leave the :run_state as :stop for all hadoop daemons in the
     worker in the cluster definition.
  2. Launch all additional workers.
  3. Set the :run_state for :hadoop_tasktracker and :hadoop_datanode
     to :start in the cluster definition and run a "knife cluster
     sync."
  4. After all workers have launched, rerun chef-client on all
     launched workers, including the first.

### Tunables

For more details on the so, so many config variables, see the Cloudera Hadoop documentation.

### Advanced Cluster-Fu for the impatient cheapskate

#### Stop-start clusters

If you have a persistent HDFS, you can shut down the cluster with `knife cluster stop` at the end of your workday, and restart it in less time than it takes to get your morning coffee.  Typical time from typing "knife cluster launch science-worker" until the node reports in the jobtracker is <= 6 minutes on launch -- faster than that on start.

Stopped nodes don't cost you anything in compute, though you do continue to pay for the storage on their attached drives. See [the example science cluster](example/clusters/science.rb) for the setup we use. 

#### Reshapable clusters

The hadoop cluster definition we use at infochimps for production runs uses its HDFS ONLY a scratch pad - anything we want to keep goes into S3.

This lets us do stupid, dangerous, awesome things like:

* spin up a few dozen c1.xlarge CPU-intensive machines, parse a ton of data,
  store it back into S3.
* blow all the workers away and reformat the namenode with the `/etc/hadoop/conf/nuke_hdfs_from_orbit_its_the_only_way_to_be_sure.sh.erb` shell script.
* spin up a cluster of m2.2xlarge memory-intensive machines to group and filter it, storing final results into S3.
* shut the entire cluster down before anyone in accounting notices.

#### Tasktracker-only workers

Who says your workers should also be datanodes? Sure, "bring the compute to the data" is the way the *robots* want you to do it, but a tasktracker-only node on an idle cluster is one you can kill with no repercussions.

This lets you blow up the size of your cluster and not have to wait later for nodes to decommission. Non-local map tasks obviously run slower-than-optimal, but we'd rather have sub-optimal robots than sub-optimal data scientists.

### Author:
      
Author:: Joshua Timberman (<joshua@opscode.com>), Flip Kromer (<flip@infochimps.com>), much code taken from Tom White (<tom@cloudera.com>)'s hadoop-ec2 scripts and Robert Berger (http://blog.ibd.com)'s blog posts.

Copyright:: 2009, Opscode, Inc; 2010, 2011 Infochimps, In

## Recipes 

* `add\_cloudera_repo`        - Add Cloudera repo to package manager
* `config\_files`             - Configure cluster
* `datanode`                 - Installs Hadoop Datanode service
* `default`                  - Base configuration for hadoop\_cluster
* `jobtracker`               - Installs Hadoop Jobtracker service
* `namenode`                 - Installs Hadoop Namenode service
* `secondarynn`              - Installs Hadoop Secondary Namenode service
* `tasktracker`              - Installs Hadoop Tasktracker service

## Integration

Supports platforms: debian and ubuntu

Cookbook dependencies:

* java
* apt
* runit
* volumes
* tuning
* silverware

## License and Author

Author::                Philip (flip) Kromer and Erik Mackdanz - Infochimps, Inc (<coders@infochimps.com>)
Copyright::             2013, Philip (flip) Kromer - Infochimps, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

> readme generated by [ironfan](http://github.com/infochimps-labs/ironfan)'s cookbook\_munger
