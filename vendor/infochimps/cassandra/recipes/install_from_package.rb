#
# Cookbook Name::       cassandra
# Description::         Install From Package
# Recipe::              install_from_package
# Author::              Benjamin Black
#
# Copyright 2011, Benjamin Black
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

include_recipe "apt" 

apt_repository "apache-cassandra" do
  uri "http://www.apache.org/dist/cassandra/debian"
  distribution "10x"
  components ["main"]
  action :add
  keyserver "pgp.mit.edu"
  key "F758CE318D77295D"
end

# According to http://wiki.apache.org/cassandra/DebianPackaging
# 2 keys need to be added.  This extra repo, which is a duplicate of the above,
# is to add the second key
apt_repository "apache-cassandra-extrakey" do
  uri "http://www.apache.org/dist/cassandra/debian"
  distribution "10x"
  components ["main"]
  action :add
  keyserver "pgp.mit.edu"
  key "2B5C1B00"
end



package "cassandra" do
  action :install
end
