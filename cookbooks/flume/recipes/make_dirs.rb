#
# Cookbook Name::       flume
# Description::         Base configuration for flume
# Recipe::              make_dirs
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
include_recipe 'volumes'

#
# Install package
#

volume_dirs('flume.collector.data' ){ path('flume/data/flume/collector') ; selects(:single) }
volume_dirs('flume.agent.data'     ){ path('flume/data/flume/agent')     ; selects(:single) }
volume_dirs('flume.zk.data'        ){ path('flume/data/flume/zk')        ; selects(:single) }
volume_dirs('flume.data'           ){ path('flume/data')                 ; selects(:single) }

directory "/usr/lib/flume/plugins" do
  owner "flume"
end
