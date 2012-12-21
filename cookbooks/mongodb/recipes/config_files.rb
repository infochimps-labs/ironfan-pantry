#
# Cookbook Name::       config_files
# Description::         Writes the mongodb config files filled with auto-discovered goodness
# Recipe::              config_files
# Author::              Philip (flip) Kromer - Infochimps, Inc
#
# Copyright 2011, Philip (flip) Kromer - Infochimps, Inc
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

#
# Conf file -- Starts daemon and sets up config file
#

template "#{node[:mongodb][:conf_dir]}/mongodb.conf" do
  source        "mongodb.conf.erb"
  backup        false
  owner         "mongodb"
  group         "mongodb"
  mode          "0644" 
  notify_startable_services(:mongodb, [:server])
end
