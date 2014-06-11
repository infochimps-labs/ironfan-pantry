#
# Cookbook Name::       elasticsearch
# Description::         Install From package
# Recipe::              install_from_package
# Author::              GoTime, modifications by Infochimps
#
# Copyright 2011, GoTime, modifications by Infochimps
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

include_recipe 'cloud_utils::srp_repo'

case node[:platform_family]
when 'rhel'

  minor_version = node[:elasticsearch][:version].scan(/^\d+\.\d+/).first

  yum_repository 'elasticsearch' do
    action    :add
    baseurl   "http://packages.elasticsearch.org/elasticsearch/#{minor_version}/centos"
    keyurl    'http://packages.elasticsearch.org/GPG-KEY-elasticsearch'
  end

  package 'elasticsearch'

else
  package 'elasticsearch' do
    options '--force-yes' # Needed for non-GPG chimps repository
    version node[:elasticsearch][:version]
  end
end
