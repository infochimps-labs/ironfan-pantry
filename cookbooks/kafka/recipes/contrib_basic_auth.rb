#
# Cookbook Name::       kafka
# Description::         Install Nginx Reverse Server Config for Basic Authentication
# Recipe::              contrib_basic_auth
# Author::              Karel Minarik (karmi@karmi.cz), modifications by Infochimps
#
# Copyright 2012, Karel Minarik, modifications by Infochimps
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

require 'webrick/httpauth/htpasswd'

node.default[:kafka][:contrib][:password_file] = File.join(node[:nginx][:dir], "kafka_contrib_basicauth.passwd")

ruby_block "create kafka-contrib basic_auth file" do
  block do
    $passwords = ::WEBrick::HTTPAuth::Htpasswd.new(node[:kafka][:contrib][:password_file])
    node[:kafka][:contrib][:auth_users].each do |user|
      $passwords.set_passwd('kafka-contrib', user[:username], user[:password])
    end
    $passwords.flush
  end
end

# ensure proper permissions
file node[:kafka][:contrib][:password_file] do
  owner node[:nginx][:user]
  group node[:nginx][:group]
  mode 0600
  action :touch
end

template File.join(node[:nginx][:dir], 'conf.d', 'kafka_contrib_proxy.conf') do
  source        "kafka_contrib_proxy.conf.erb"
  owner         node[:nginx][:user]
  group         node[:nginx][:group]
  mode          0644
  variables     ({
    :kafka_contrib      => node[:kafka][:contrib],
  })
    
  notifies      :restart, "service[nginx]"
end
