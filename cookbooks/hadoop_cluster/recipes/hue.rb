#
# Cookbook Name::       hadoop_cluster
# Description::         Installs Hadoop Hue (Browser frontend for Hadoop)
# Recipe::              hue
# Author::              Josh Bronson - Infochimps, Inc
#
# Copyright 2012 Infochimps, Inc
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

if node[:hadoop][:hue][:install_method] == 'release'
  include_recipe "hadoop_cluster::hue_install_from_release"
else
  # Add the dead snakes repo for python2.6. necessary for ubuntu 12.04
  # and later with older versions of Hue.
  if node[:platform_family] == 'debian'
    apt_repository 'deadsnakes' do
      uri             'http://ppa.launchpad.net/fkrull/deadsnakes/ubuntu'
      distribution    node[:lsb][:codename]
      components      ['main']
      key             "DB82666C"
      keyserver       "keyserver.ubuntu.com"
      action          :add
    end
    package ("python2.6-dev")
  end

  package("hue-common")
  package("hue-plugins")
end
