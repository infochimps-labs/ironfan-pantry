#
# Cookbook Name::       zookeeper
# Description::         Base configuration for zookeeper
# Recipe::              default
# Author::              Chris Howe - Infochimps, Inc
#
# Copyright 2010, Infochimps, Inc.
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

include_recipe "apt"
include_recipe "volumes"
include_recipe "metachef"
include_recipe "java" ; complain_if_not_sun_java(:cassandra)

include_recipe "hadoop_cluster::add_cloudera_repo"

#
# Install package
#

package "hadoop-zookeeper"

#
# Configuration files
#

standard_dirs('zookeeper.server') do
  directories   :conf_dir, :log_dir
end
