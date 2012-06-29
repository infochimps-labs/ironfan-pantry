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
include_recipe 'elasticsearch'

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

jars = %w[
           plugins/cloud-aws/commons-logging-1.1.1.jar
           plugins/cloud-aws/commons-codec-1.3.jar
           plugins/cloud-aws/aws-java-sdk-1.2.7.jar
           plugins/cloud-aws/elasticsearch-cloud-aws-0.17.10.jar
           plugins/cloud-aws/httpclient-4.1.1.jar
           plugins/cloud-aws/httpcore-4.1.jar
           lib/jline-0.9.94.jar
           lib/lucene-queries-3.4.0.jar
           lib/elasticsearch-0.17.10.jar
           lib/lucene-highlighter-3.4.0.jar
           lib/lucene-memory-3.4.0.jar
           lib/log4j-1.2.16.jar
           lib/lucene-core-3.4.0.jar
           lib/lucene-analyzers-3.4.0.jar
           lib/jna-3.2.7.jar
           lib/sigar/sigar-1.6.4.jar
          ]

jars.each do |jar|
  link File.join(node[:flume]        [:home_dir], 'lib', File.basename(jar)) do
    to File.join(node[:elasticsearch][:home_dir], jar)
  end
end
