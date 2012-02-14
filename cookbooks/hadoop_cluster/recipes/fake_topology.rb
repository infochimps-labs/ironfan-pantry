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
# You may find yourself in a world where there is no rack, there is no locality,
# there is only node (for instance, if you're on EC2). The notion is still
# useful however...
#
# the attached template

if node[:hadoop][:define_topology]
  template "#{node[:hadoop][:conf_dir]}/hadoop-topologizer.rb" do
    owner         "root"
    mode          "0755"
    variables({   :hadoop => hadoop_config_hash,
        :hadoop_datanodes => discover_all(:hadoop, :datanode) })
    source        "hadoop-topologizer.rb.erb"
  end
end
