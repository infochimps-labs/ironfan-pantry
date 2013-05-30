#
# Cookbook Name::       hadoop_cluster
# Description::         Formats the HDFS
# Recipe::              format_hdfs
# Author::              Nathaniel Eliot - Infochimps, Inc
#
# Copyright 2013, Infochimps, Inc
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

class Chef::Resource::RubyBlock ; include HadoopCluster ; end

# Running this as a block so we can see the bootstrap output
ruby_block "format HDFS namenode" do
  block do
    Chef::Log.info(%x[echo Y | #{node[:hadoop][:conf_dir]}/bootstrap_hadoop_namenode.sh])
  end
  not_if do
    File.exists? "#{node[:hadoop][:namenode][:data_dirs].last}/current"
  end
  hadoop_services.each do |svc|
    if startable?(node[:hadoop][svc])
      notifies :restart, "service[hadoop_#{svc}]", :delayed
    end
  end
end

