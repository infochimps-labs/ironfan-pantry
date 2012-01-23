#
# Cookbook Name:: route53
# Resource:: rr
#
# Author:: Adam Jacob <adam@opscode.com>
# Copyright:: 2010, Opscode, Inc <legal@opscode.com>
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

actions :create, :update #, :delete, :replace

attribute :fqdn, :kind_of => String
attribute :type, :kind_of => String
attribute :values, :kind_of => Array
attribute :ttl, :kind_of => String

attribute :aws_access_key_id, :kind_of => String
attribute :aws_secret_access_key, :kind_of => String

attribute :zone, :kind_of => String
