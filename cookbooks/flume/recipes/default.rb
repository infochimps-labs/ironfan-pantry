#
# Cookbook Name::       flume
# Description::         Base configuration for flume
# Recipe::              default
# Author::              Chris Howe - Infochimps, Inc
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
#

include_recipe 'silverware'
include_recipe 'java' ; complain_if_not_sun_java(:flume)
include_recipe 'volumes'
include_recipe 'hadoop_cluster::add_cloudera_repo'
class Chef::Resource::Template ; include FlumeCluster ; end

#
# Install package
#

daemon_user('flume')

package     'flume'

# FIXME: the AWS part should be separated into its own recipe
gem_package('right_aws'){ action :nothing }.run_action(:install)
require 'right_aws'

#
# Install package
#

standard_dirs('flume') do
  directories [:home_dir, :conf_dir, :pid_dir]
end

volume_dirs('flume.collector.data' ){ path('flume/data/flume/collector') ; selects(:single) }
volume_dirs('flume.agent.data'     ){ path('flume/data/flume/agent')     ; selects(:single) }
volume_dirs('flume.zk.data'        ){ path('flume/data/flume/zk')        ; selects(:single) }
volume_dirs('flume.data'           ){ path('flume/data')                 ; selects(:single) }

directory "/usr/lib/flume/plugins" do
  owner "flume"
end
