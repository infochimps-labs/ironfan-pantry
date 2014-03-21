#
# Cookbook Name::       vayacondios_old
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

node[:vayacondios_old][:password_file] = File.join(node[:vayacondios_old][:conf_dir], "basicauth.passwd")

ruby_block "create vayacondios_old basic_auth file" do
  block do
    $passwords = ::WEBrick::HTTPAuth::Htpasswd.new(node[:vayacondios_old][:password_file])
    node[:vayacondios_old][:users].each do |user|
      $passwords.set_passwd('vayacondios_old', user[:username], user[:password])
    end
    $passwords.flush
  end
end

# FIXME: nginx should be run after this recipe, but we need to ensure
# that the nginx directory exists in order to place a template
# there.
directory node[:nginx][:dir] do
  mode 0755
  action :create
end

template File.join(node[:nginx][:dir], 'conf.d', 'vayacondios__old_proxy.conf') do
  source        "vayacondios_proxy.conf.erb"
  owner         node[:vayacondios_old][:user]
  group         node[:vayacondios_old][:group]
  mode          0644
  variables     ({
    :vayacondios_old      => node[:vayacondios_old],
  })
end

# ensure proper permissions
file node[:vayacondios_old][:password_file] do
  owner node[:nginx][:user]
  group node[:nginx][:user]
  mode 0600
  action :touch
end
