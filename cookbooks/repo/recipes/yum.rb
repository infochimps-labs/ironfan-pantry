#
# Cookbook Name::       repo
# Description::         Sets up apt repository
# Recipe::              yum
# Author::              Brandon Bell - Infochimps, Inc
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

package 'rpm'
package 'yum-utils'

directory node[:repo][:yum][:base] do
  owner	"root"
  group	"root"
  mode	0755
  action :create
end

template "/usr/local/sbin/reposync.sh" do
  source "reposync.sh.erb"
  mode 0755
end
