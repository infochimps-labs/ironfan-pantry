#
# Cookbook Name::       motd
# Description::         Ec2
# Recipe::              ec2
# Author::              Dhruv Bansal - Infochimps, Inc
#
# Copyright 2011, Dhruv Bansal - Infochimps, Inc
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

node.set[:motd][:instance_id]           = node[:ec2][:instance_id]      || ''
node.set[:motd][:instance_type]         = node[:ec2][:instance_type]    || ''
node.set[:motd][:public_hostname]       = node[:ec2][:public_hostname]  || ''
node.set[:motd][:security_groups]       = node[:ec2][:security_groups]  || []

