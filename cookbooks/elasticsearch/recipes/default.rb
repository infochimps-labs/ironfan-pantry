#
# Cookbook Name::       elasticsearch
# Description::         Base configuration for elasticsearch
# Recipe::              default
# Author::              GoTime, modifications by Infochimps
#
# Copyright 2010, GoTime
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

include_recipe "aws"
include_recipe "volumes"
include_recipe "metachef"
include_recipe "java" ; complain_if_not_sun_java(:elasticsearch)

daemon_user(:elasticsearch) do
  create_group  true
end

standard_dirs('elasticsearch') do
  directories   [:conf_dir, :log_dir, :lib_dir, :pid_dir]
  group         'root'
end
