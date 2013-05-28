#
# Cookbook Name:: xfs
# Recipe:: default
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

if platform?("redhat") and node[:platform_version] >= '6.0'
  remote_file "/tmp/xfsprogs.x86_64.rpm" do
    source node[:xfs][:rhel][:rpm_url]
    action :create_if_missing
  end
  rpm_package "/tmp/xfsprogs.x86_64.rpm" do
    action :install
  end
else
  %w{ xfsprogs xfsdump }.each do |pkg|
    package pkg
  end

  package "xfslibs-dev" do
    package_name "xfsprogs-devel" if platform?("redhat", "centos","scientific","fedora")
  end
end
