#
# Cookbook Name::       nodejs
# Description::         Base configuration for nodejs
# Recipe::              default
# Author::              Nathaniel Eliot - Infochimps, Inc
#
# Copyright 2011, Infochimps
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

include_recipe 'python'

package "python-software-properties" if platform?('ubuntu')

if platform?('centos')
  execute "yum clean all" do
    action :nothing
  end

  remote_file "/etc/yum.repos.d/nodejs-stable.repo" do
    source "http://nodejs.tchol.org/repocfg/el/nodejs-stable.repo"
    mode "0644"
    notifies :run, resources(:execute => "yum clean all"), :immediately
  end
end

package "nodejs"
