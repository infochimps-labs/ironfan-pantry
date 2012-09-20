#
# Cookbook Name::       flume
# Description::         Test S3 Source
# Recipe::              test_s3_source
# Author::              Travis Dempsey - Infochimps, Inc
#
# Copyright 2011, Travis Dempsey - Infochimps, Inc
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

class Chef::Resource::FlumeLogicalNode ; include FlumeCluster ; end

# FIXME: the AWS part should be separated into its own recipe
gem_package('right_aws'){ action :nothing }.run_action(:install)
require 'right_aws'

flume_logical_node "sample" do
  source        s3_source("s3://infochimps-data/test/twitter.json")
  sink          "console"
  flow          "test_flow"
  physical_node node[:fqdn]
  flume_master  discover(:flume, :master).private_ip
  action        [:spawn,:config]
end
