#
# Cookbook Name::       s3fs
# Description::         Base configuration for s3fs
# Recipe::              default
# Author::              Brandon Bell - Infochimps, Inc
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

include_recipe 's3fs::install_from_release'

template "/etc/passwd-s3fs" do
  source        "passwd-s3fs.erb"
  mode          "0600"
  variables ( { :aws => node[:aws] } )
end

node[:s3fs][:mounts].each_pair do |s3bucket, target|

  directory target do
    action :create
    group  'root' 
    mode   0755
    owner  'root'
  end

  mount target do
    device "s3fs##{s3bucket}"
    fstype "fuse"
    options node[:s3fs][:options]
    dump 0 
    pass 0 
    action [ :mount ]
    not_if "cat /proc/mounts | grep #{target}"
  end

end
