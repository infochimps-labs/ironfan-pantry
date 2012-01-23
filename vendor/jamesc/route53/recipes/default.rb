#
# Cookbook Name:: route53
# Recipe:: default
#
# Copyright 2010, Platform14.com.
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

# Force immediate install of these packages

package("libxml2-dev"      ){ action :nothing }.run_action(:install)
package("libxslt-dev"      ){ action :nothing }.run_action(:install)
gem_package("fog"          ){ action :nothing }.run_action(:install)
gem_package("net-ssh-multi"){ action :nothing }.run_action(:install)

# Source the fog gem, forcing Gem to recognize new version if any

require 'rubygems' unless defined?(Gem)
Gem.clear_paths
require 'fog'
