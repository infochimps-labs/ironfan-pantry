#
# Cookbook Name::       vayacondios
# Description::         Install Nginx Reverse Server Config for Basic Authentication
# Recipe::              basic_auth
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

node.default[:vayacondios][:password_file] = File.join(node[:vayacondios][:conf_dir], "basicauth.passwd")

# ensure proper permissions
file node[:vayacondios][:password_file] do
  owner node[:nginx][:user]
  group node[:nginx][:user]
  mode 0600
  action :touch
end

ruby_block "create vayacondios basic_auth file" do
  block do
    $passwords = ::WEBrick::HTTPAuth::Htpasswd.new(node[:vayacondios][:password_file])
    node[:vayacondios][:users].each do |user|
      $passwords.set_passwd('Vayacondios', user[:username], user[:password])
    end
    $passwords.flush
  end
end

template File.join(node[:nginx][:dir], 'conf.d', 'vayacondios_proxy.conf') do
  source        "vayacondios_proxy.conf.erb"
  owner         node[:vayacondios][:user]
  group         node[:vayacondios][:group]
  mode          0644
  variables     ({
    :vayacondios      => node[:vayacondios],
  })
end
