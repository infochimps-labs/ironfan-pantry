#
# Cookbook Name::       jenkins
# Description::         Creates the home directory for the node worker and sets 'JENKINS_HOME' and 'JENKINS_URL' system environment variables.  The 'winsw'[1] Windows service wrapper will be downloaded and installed, along with generating `jenkins-worker.xml` from a template.  Jenkins is configured with the node as a 'jnlp'[2] worker and '/jnlpJars/worker.jar' is downloaded from the Jenkins server.  The 'jenkinsworker' service will be started the first time the recipe is run or if the service is not running.  The 'jenkinsworker' service will be restarted if '/jnlpJars/worker.jar' has changed.  The end results is functionally the same had you chosen the option to 'Let Jenkins control this worker as a Windows service'[3].
#
# [1] http://weblogs.java.net/blog/2008/09/29/winsw-windows-service-wrapper-less-restrictive-license
# [2] http://wiki.jenkins-ci.org/display/JENKINS/Distributed+builds
# [3] http://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+as+a+Windows+service
# Recipe::              node_windows
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

home = node[:jenkins][:worker][:home_dir]
url  = node[:jenkins][:server][:url]

jenkins_exe = "#{home}\\jenkins-slave.exe"
service_name = "jenkinsworker"

directory home do
  action :create
end

env "JENKINS_HOME" do
  action :create
  value home
end

env "JENKINS_URL" do
  action :create
  value url
end

template "#{home}/jenkins-worker.xml" do
  source "jenkins-worker.xml"
  variables(:jenkins_home => home,
            :jnlp_url => "#{url}/computer/#{node[:jenkins][:worker][:name]}/slave-agent.jnlp")
end

#XXX how-to get this directly from the jenkins server?
remote_file jenkins_exe do
  source "http://maven.dyndns.org/2/com/sun/winsw/winsw/1.8/winsw-1.8-bin.exe"
  not_if { File.exists?(jenkins_exe) }
end

execute "#{jenkins_exe} install" do
  cwd home
  only_if { WMI::Win32_Service.find(:first, :conditions => {:name => service_name}).nil? }
end

service service_name do
  action :nothing
end

jenkins_node node[:jenkins][:worker][:name] do
  description  node[:jenkins][:worker][:description]
  executors    node[:jenkins][:worker][:executors]
  remote_fs    node[:jenkins][:worker][:home_dir]
  labels       node[:jenkins][:worker][:labels]
  mode         node[:jenkins][:worker][:mode]
  launcher     node[:jenkins][:worker][:launcher]
  mode         node[:jenkins][:worker][:mode]
  availability node[:jenkins][:worker][:availability]
end

remote_file "#{home}\\slave.jar" do
  source "#{url}/jnlpJars/slave.jar"
  notifies :restart, resources(:service => service_name), :immediately
end

service service_name do
  action :start
end
