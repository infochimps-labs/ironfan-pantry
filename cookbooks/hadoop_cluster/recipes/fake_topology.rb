#
# Cookbook Name::       hadoop_cluster
# Description::         Pretend that groups of machines are on different racks so you can execute them without guilt
# Recipe::              fake_topology
# Author::              Philip (flip) Kromer - Infochimps, Inc
#
# Copyright 2011, Philip (flip) Kromer - Infochimps, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# NOTE: this is a filthy albeit very useful hack that has no presence on a production cluster.
#

#
# You may find yourself in a world where there is no rack, there is no locality,
# there is only node (for instance, if you're on EC2). The rack notion is still
# useful however...
#
# The HDFS guarantees that the first replica will be stored on a different rack
# than the original if at all possible.  If we nominate the first _n_ machines
# to be on one "rack", and the remainder on a different "rack", you can
# hard-stop the machines on the high rack without having to slowly decommission
# their datanodes.
#
# Silly? yes. Economical? yes. Now you can define a say 20 machine cluster with
# 6 nodes on "rack zero" and 14 on "rack two". Develop your job on the 6-node
# version, burst up to 20 nodes for anything serious, then park those machines
# when complete. Bolt on an extra 10 tasktracker-only nodes and you can burst
# your working-size six machine cluster up to 30 nodes while working off the
# same HDFS the whole time.
#
# Notes:
#
# * make sure to over-provision storage for machines on the first rack: shutting
#   down the ephemeral rack causes all the data to replicate (the replication
#   factor is honored even if an alternate rack isn't available).
#
# * this will increase the number of non-local map tasks. Compared to the cost
#   savings, you're well ahead on specific processing power though
#
# * This hack works, and we stop-start machines all the time, but shutting down
#   10 nodes at once on a live HDFS not a risk-free endeavour. We only run this
#   on clusters for exploratory analytics, where we park final state datasets
#   onto S3. If data loss occurred we'd shrug our shoulders and re-run the whole
#   workflow. If that's not your use case, be patient and use Hadoop's [decommission
#   method](http://developer.yahoo.com/hadoop/tutorial/module2.html#decommission).
#
# After you apply this change, Hadoop will NOT migrate blocks to correct rack
# policy for you. You should increase the replication factor of the files on
# your HDFS with something like `hadoop fs -setrep -R 4 /`, let Hadoop rebalance
# blocks, then decrease it to your usual level: `hadoop fs -setrep -R 3 /`. This
# will temporarily increse the amount of disk space used by a third, so keep
# your eyes open. Run `hadoop fsck / -racks` to see files that are not
# rack-balanced; run
#
#   for foo in `hadoop fsck -locations | grep policy |  cut -d: -f1` ; do
#     hadoop fs -setrep  -R 4 $foo ;
#   done
#
# to clean up any stragglers.

if node[:hadoop][:define_topology]
  template "#{node[:hadoop][:conf_dir]}/hadoop-topologizer.rb" do
    owner         "root"
    mode          "0755"
    variables({   :hadoop => hadoop_config_hash,
        :hadoop_datanodes => discover_all(:hadoop, :datanode) })
    source        "hadoop-topologizer.rb.erb"
  end
end
