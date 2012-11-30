#
# Cookbook Name::       hadoop_cluster
# Description::         Installs Hadoop Tasktracker service
# Recipe::              tasktracker
# Author::              Philip (flip) Kromer - Infochimps, Inc
#
# Copyright 2009, Opscode, Inc.
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

include_recipe 'hadoop_cluster'
include_recipe 'runit'

hadoop_service(:tasktracker)

announce(:hadoop, :tasktracker, {
           :logs  => { :tasktracker => node[:hadoop][:tasktracker][:log_dir] },
           :ports => {
             :dash_port     => { :port => node[:hadoop][:tasktracker][:dash_port],
                                 :dashboard => true, :protocol => 'http' },
             :jmx_dash_port => { :port => node[:hadoop][:tasktracker][:jmx_dash_port],
                                 :dashboard => true},
           },
           :daemons => {
             :tasktracker => {
               :name => 'java',
               :user => node[:hadoop][:tasktracker][:user],
               :cmd  => 'org.apache.hadoop.mapred.TaskTracker'
             }
           }
         })
