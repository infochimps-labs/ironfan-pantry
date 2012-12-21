#
# Cookbook Name::       mongodb
# Description::         Install From Release
# Recipe::              install_from_release
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

include_recipe 'install_from'

install_from_release(:mongodb) do

  arch = node[:kernel][:machine].to_sym
  release_url   node[:mongodb][arch][:release_url]
  checksum      node[:mongodb][arch][:checksum]

  home_dir      node[:mongodb][:home_dir]
  version       node[:mongodb][:version]
  action        [ :install ]
  has_binaries  [ 'bin/mongod', 'bin/mongo' ]

end
