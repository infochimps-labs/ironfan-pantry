#
# Cookbook Name::	kafka
# Description::     Base configuration for Kafka
# Recipe::			default
#
# Copyright 2012, Webtrends, Inc. modifications by Infochimps
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

# == Recipes
include_recipe "java"
include_recipe "runit"

if node[:kafka][:broker_id].nil? || node[:kafka][:broker_id].empty?
    node[:kafka][:broker_id] = node[:ipaddress].gsub(".","")[0...9]
end

if node[:kafka][:broker_host_name].nil? || node[:kafka][:broker_host_name].empty?
    node[:kafka][:broker_host_name] = node[:fqdn]
end

log "Broker id: #{node[:kafka][:broker_id]}"
log "Broker name: #{node[:kafka][:broker_host_name]}"

