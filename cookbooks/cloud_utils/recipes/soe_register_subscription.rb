#
# Cookbook Name::       cloud_utils
# Description::         SOE 
# Recipe::              soe_register_subscription
# Author::              Erik Mackdanz - Infochimps, Inc
#
# Copyright 2014, Erik Mackdanz - Infochimps, Inc
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

# Use platform? instead of platform_family? since
# recipe not applicable to CentOS
if platform? "redhat"

  template '/etc/init.d/soe-register' do
    owner 'root'
    mode '0755'
    variables(:user => node[:rhel_subs][:useremail],
              :password => node[:rhel_subs][:password],
              :pool => node[:rhel_subs][:pool],
              )
    source 'soe-register.init.erb'
  end

  service 'soe-register' do
    action [ :enable, :start]
  end
end
