#
# Cookbook Name::       s3fs
# Description::         Install from release
# Recipe::              install_from_release
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

include_recipe 'install_from'

case node['platform']
when "ubuntu","debian"
  %w{build-essential libfuse-dev fuse-utils libcurl4-openssl-dev libxml2-dev mime-support}.each do |pkg|
    package pkg do
      action :install
    end
  end
when "centos","redhat","fedora"
  %w{gcc libstdc++-devel gcc-c++ fuse fuse-devel curl-devel libxml2-devel openssl-devel mailcap}.each do |pkg|
    package pkg do
      action :install
    end
  end
end

install_from_release(:s3fs) do
  release_url   node[:s3fs][:release_url]
  version       node[:s3fs][:version]
  action        [ :configure_with_autoconf, :install_with_make ]
  not_if{ ::File.exists?("/usr/local/bin/s3fs") }
end
