#
# Cookbook Name::       hadoop_cluster
# Description::         Installs Hadoop Jobtracker service
# Recipe::              jobtracker
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

hadoop_service(:jobtracker)

# Don't attempt to do a rolling rotate of single files created, just drop
#   them if they're over two weeks old.
logrotate_single_files = {
  :daily => nil,
  :dateext => nil,
  :dateformat => nil,
  :delaycompress => nil,
  :copytruncate => nil,
  :compress => nil,
  :missingok => true,
  :maxage => 14,
  :olddir => nil,
  :rotate => 0
}

announce(:hadoop, :jobtracker, {
           :logs => { 
             :jobtracker => { 
               :glob => node[:hadoop][:log_dir] + '/hadoop-hadoop-jobtracker-*.log' 
             },
             :jobs => logrotate_single_files.merge({
               :glob => node[:hadoop][:log_dir] + '/job_*_conf.xml',
             }),
             :history => logrotate_single_files.merge({
               :path => node[:hadoop][:log_dir],
               :glob => node[:hadoop][:log_dir] + '/history/done/* ' \
                      + node[:hadoop][:log_dir] + '/history/done/.*.crc ',
             })
           },
           :ports => {
             :dash_port     => { :port => node[:hadoop][:jobtracker][:dash_port],
                                 :dashboard => true, :protocol => 'http' }, 
             :jmx_dash_port => { :port => node[:hadoop][:jobtracker][:jmx_dash_port],
                                 :dashboard => true},
           },
           :daemons => {
             :jobtracker => {
               :name => 'java',
               :user => node[:hadoop][:jobtracker][:user],
               :cmd  => 'proc_jobtracker'
             }
           }
         })

