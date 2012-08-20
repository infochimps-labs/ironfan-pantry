#
# Cookbook Name::       jenkins
# Description::         Server
# Recipe::              server
# Author::              Doug MacEachern <dougm@vmware.com>
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

include_recipe 'jenkins'

announce(:jenkins, :server,
  :port => node[:jenkins][:server][:port],
  :user => node[:jenkins][:server][:user]
  )

daemon_user('jenkins.server') do
  shell         "/bin/sh"
  home          node[:jenkins][:server][:home_dir]
  manage_home   true
end

standard_dirs('jenkins.server') do
  directories   :conf_dir, :pid_dir, :log_dir
end

directory node[:jenkins][:server][:home_dir] do
  owner         node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
  mode          "0755"
  action        :create
end

directory "#{node[:jenkins][:server][:home_dir]}/war" do
  owner         node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
  mode          "0755"
  action        :create
end

package "jenkins"

case node.platform
when "ubuntu", "debian"

  include_recipe 'runit'
  package        "daemon"

  template '/etc/default/jenkins' do
    source        'etc-default-jenkins.erb'
    mode          "0644"
    action        :create
    notifies      :restart,  "service[jenkins_server]"
    variables     :jenkins => node[:jenkins]
  end

  service "jenkins_server" do
    service_name  'jenkins'
    action        node[:jenkins][:server][:run_state]
    #options       Mash.new(:service_name => 'jenkins_server').merge(node[:jenkins])
  end
  # kill_old_service("jenkins") do
  #   only_if{ File.exists?("/etc/init.d/jenkins") }
  # end

when /mac_os_x/

  template '/Library/LaunchDaemons/org.jenkins-ci.jenkins_server.plist' do
    source      "org.jenkins-ci.jenkins_server.plist.erb"
    variables   :jenkins => node[:jenkins], :startable => startable?(node[:jenkins][:server])
  end

  service "jenkins_server" do
    provider    Chef::Provider::Service::Macosx
    action      node[:jenkins][:server][:run_state]
  end

  Chef::Log.debug <<EOF
Currently cannot launch jenkins service on #{node.platform}, you're on your own.

Here's what brew recommends:

  If this is your first install, automatically load on login with:
    mkdir -p ~/Library/LaunchAgents
  cp /usr/local/Cellar/jenkins/*/homebrew.mxcl.jenkins.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.jenkins.plist

  If this is an upgrade and you already have the homebrew.mxcl.jenkins.plist loaded:
    launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.jenkins.plist
  cp /usr/local/Cellar/jenkins/*/homebrew.mxcl.jenkins.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.jenkins.plist

  Or start it manually:
    java -jar /usr/local/Cellar/jenkins/*/lib/jenkins.war

EOF

else
  Chef::Log.warn "Don't know how to install jenkins service on platform #{node.platform}, you're on your own"
end
