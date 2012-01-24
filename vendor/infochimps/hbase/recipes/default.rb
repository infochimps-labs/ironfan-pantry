#
# Cookbook Name::       hbase
# Description::         Base configuration for hbase
# Recipe::              default
# Author::              Chris Howe - Infochimps, Inc
#
# Copyright 2011, Chris Howe - Infochimps, Inc
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

include_recipe "java::sun"
include_recipe "apt"
include_recipe "volumes"
include_recipe "hadoop_cluster"
include_recipe "zookeeper::client"
include_recipe "ganglia"

include_recipe "hadoop_cluster::add_cloudera_repo"

#
# Users
#

daemon_user(:hbase)

# Install
package "hadoop-hbase"

standard_dirs('hbase') do
  directories   :conf_dir, :pid_dir, :tmp_dir, :log_dir
end

node[:hbase][:services].each do |svc|
  directory("#{node[:hbase][:log_dir]}/#{svc}"){ action(:create) ; owner 'hbase' ; group 'hbase'; mode "0755" }
end

# JMX should listen on the public interface
node[:hbase][:jmx_dash_addr] = public_ip_of(node)

# FIXME: don't hardcode these...
link("#{node[:hbase][:home_dir]}/hbase.jar"      ){ to "hbase-0.90.4-cdh3u2.jar"       }
link("#{node[:hbase][:home_dir]}/hbase-tests.jar"){ to "hbase-0.90.4-cdh3u2-tests.jar" }

# Stuff the HBase jars into the classpath
node[:hadoop][:extra_classpaths][:hbase] = '/usr/lib/hbase/hbase.jar:/usr/lib/hbase/conf'
node[:hbase][:exported_jars]   = [ "#{node[:hbase][:home_dir]}/hbase.jar", "#{node[:hbase][:home_dir]}/hbase-tests.jar", ]
node[:hbase][:exported_confs]  = [ "#{node[:hbase][:conf_dir]}/hbase-default.xml", "#{node[:hbase][:conf_dir]}/hbase-site.xml",]
