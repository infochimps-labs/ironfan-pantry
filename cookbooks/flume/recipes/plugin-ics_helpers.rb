#
# Cookbook Name::       flume
# Description::         Infochimps Helper Plugins
# Recipe::              plugin-ics_helpers
# Author::              Josh Bronson - Infochimps, Inc
#
# Copyright 2012, Infochimps, Inc.
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

include_recipe 'silverware'

cookbook_file "/usr/lib/flume/plugins/ics-helpers.jar" do
  source "ics-helpers.jar"
  owner "flume"
  mode "0644"
end

# Load HttpSource as a plugin
node[:flume][:plugins][:helper_plugins]  ||= {}
node[:flume][:plugins][:helper_plugins][:classes] =  [
                                                   "com.infochimps.flume.handlers.ElasticSearchSink",
                                                   "com.infochimps.flume.handlers.HttpSource",
                                                  ]

# Make sure that ics-helpers.jar and http-site.xml can be located on the classpath
node[:flume][:plugins][:helper_plugins][:classpath]  =  [ "/usr/lib/flume/plugins/ics-helpers.jar", "/etc/http/conf" ]

node[:flume][:plugins][:helper_plugins][:java_opts] =  []

node[:flume][:exported_jars] += [
  "#{node[:flume][:home_dir]}/plugins/ics-helpers.jar",
]

node_changed!
