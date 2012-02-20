#
# Cookbook Name::       jenkins
# Description::         Creates the user and group for the Jenkins worker to run as and '/jnlpJars/slave.jar' is downloaded from the Jenkins server.  Depends on runit_service from the runit cookbook.
# Recipe::              node_jnlp
# Author::              Doug MacEachern <dougm@vmware.com>
# Author::              Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2010, VMware, Inc.
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

include_recipe 'runit'

package 'groovy'

service_name = "jenkins-worker"
worker_jar = "#{node[:jenkins][:worker][:home_dir]}/slave.jar"

group node[:jenkins][:worker][:user] do
end

user node[:jenkins][:worker][:user] do
  comment "Jenkins CI node (jnlp)"
  gid node[:jenkins][:worker][:user]
  home node[:jenkins][:worker][:home_dir]
end

directory node[:jenkins][:worker][:home_dir] do
  action :create
  owner node[:jenkins][:worker][:user]
  group node[:jenkins][:worker][:user]
end

jenkins_node node[:jenkins][:worker][:name] do
  description  node[:jenkins][:worker][:description]
  executors    node[:jenkins][:worker][:executors]
  remote_fs    node[:jenkins][:worker][:home_dir]
  labels       node[:jenkins][:worker][:labels]
  mode         node[:jenkins][:worker][:mode]
  launcher     "jnlp"
  mode         node[:jenkins][:worker][:mode]
  availability node[:jenkins][:worker][:availability]
end

remote_file worker_jar do
  source "#{node[:jenkins][:server][:url]}/jnlpJars/slave.jar"
  owner node[:jenkins][:worker][:user]
  #only restart if slave.jar is updated
  if ::File.exists?(worker_jar)
    notifies :restart, "service[#{service_name}]", :immediately
  end
end

runit_service service_name
