#
# Cookbook Name::       jenkins
# Description::         Creates the user and group for the Jenkins worker to run as and sets `.ssh/authorized_keys` to the 'jenkins[:public_key]' attribute.  The 'jenkins-cli.jar'[1] is downloaded from the Jenkins server and used to manage the nodes via the 'groovy'[2] cli command.  Jenkins is configured to launch a worker agent on the node using its SSH worker plugin[3].
#
# [1] http://wiki.jenkins-ci.org/display/JENKINS/Jenkins+CLI
# [2] http://wiki.jenkins-ci.org/display/JENKINS/Jenkins+Script+Console
# [3] http://wiki.jenkins-ci.org/display/JENKINS/SSH+Workers+plugin
# Recipe::              node_ssh
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

# ===========================================================================
#
# !!! NOTE !!!!
#
# This recipe doesn't seem to work.
# Any interested party should consider using the jenkins gem instead:
#   http://rubydoc.info/gems/jenkins/0.6.1/file/README.md
#

include_recipe 'jenkins'

ssher = discover(:jenkins, :ssher)

daemon_user('jenkins.worker') do
  shell         node[:jenkins][:worker][:shell]
  home          node[:jenkins][:worker][:home_dir]
  manage_home   true
end

standard_dirs('jenkins.worker') do
  directories   :conf_dir, :pid_dir, :log_dir
end

directory node[:jenkins][:worker][:home_dir] do
  owner         node[:jenkins][:worker][:user]
  group         node[:jenkins][:worker][:group]
  mode          "0755"
  action        :create
end

directory "#{node[:jenkins][:worker][:home_dir]}/.ssh" do
  action        :create
  mode          "0700"
  owner         node[:jenkins][:worker][:user]
  group         node[:jenkins][:worker][:group]
end

public_key = ssher && ssher.info[:public_key]
if public_key
  file "#{node[:jenkins][:worker][:home_dir]}/.ssh/authorized_keys" do
    action      :create
    mode        "0600"
    owner       node[:jenkins][:worker][:user]
    group       node[:jenkins][:worker][:group]
    content     public_key
  end
end

# jenkins_node node[:jenkins][:worker][:name] do
#   description  node[:jenkins][:worker][:description]
#   executors    node[:jenkins][:worker][:executors]
#   remote_fs    node[:jenkins][:worker][:home_dir]
#   labels       node[:jenkins][:worker][:labels]
#   mode         node[:jenkins][:worker][:mode]
#   launcher     "ssh"
#   mode         node[:jenkins][:worker][:mode]
#   availability node[:jenkins][:worker][:availability]
#   env          node[:jenkins][:worker][:env]
#   #ssh options
#   host         node[:jenkins][:worker][:ssh_host]
#   port         node[:jenkins][:worker][:ssh_port]
#   username     node[:jenkins][:worker][:ssh_user]
#   password     node[:jenkins][:worker][:ssh_pass]
#   private_key  node[:jenkins][:worker][:ssh_private_key]
#   jvm_options  node[:jenkins][:worker][:jvm_options]
# end

file "#{node[:jenkins][:worker][:home_dir]}/.gitconfig" do
  owner         node[:jenkins][:worker][:user]
  mode          "0600"
  content <<EOF
[user]
        name            = Philip (flip) Kromer
        email           = flip@infochimps.com
EOF
end
