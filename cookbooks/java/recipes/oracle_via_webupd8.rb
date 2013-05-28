#
# Author:: Nathaniel Eliot (<temujin9@infochimps.com>)
# Cookbook Name:: java
# Recipe:: oracle_via_webupd8
#
# Copyright 2011, Infochimps, Inc.
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

include_recipe 'apt'

java_home = node['java']["java_home"]
jdk_version = node['java']['jdk_version'].to_s
pkg_name = "oracle-java#{jdk_version}-installer"

Chef::Application.fatal!("Ubuntu only") unless platform?("ubuntu")

apt_repository "webupd8team-oracle-java" do
  uri "http://ppa.launchpad.net/webupd8team/java/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  action :add
  keyserver "keyserver.ubuntu.com"
  key "EEA14886"
  notifies :run, "execute[apt-get update]", :immediately
  notifies :run, "execute[accept Oracle's license]", :immediately
#   notifies :run, "execute[update java alternatives]", :immediately
  not_if { File.exists? '/etc/apt/sources.list.d/webupd8team-oracle-java.list' }
end

execute "accept Oracle's license" do
  config = "#{pkg_name} shared/accepted-oracle-license-v1-1 select true"
  command "echo #{config} | /usr/bin/debconf-set-selections"
  action :nothing
end

package pkg_name

ruby_block  "set-env-java-home" do
  block do
    ENV["JAVA_HOME"] = java_home
  end
end

file "/etc/profile.d/jdk.sh" do
  content "export JAVA_HOME=#{java_home}"
  mode 0755
end

link("/usr/lib/java-#{jdk_version}-oracle").to "/usr/lib/default-java"

jvm = "/usr/lib/jvm/java-#{jdk_version}-oracle"
link(java_home).to jvm

# FIXME: this should be triggered by install only, but a bad version got burned
#   onto the AMI, so there's no good way to make this idempotent and yet ensure
#   that it executes on those bad images. Clean this up once the problem has been
#   corrected everywhere (including the newest image).
execute "update java alternatives" do
  command "update-alternatives --set java #{jvm}/jre/bin/java"
#   action :nothing
end

