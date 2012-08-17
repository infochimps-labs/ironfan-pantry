#
# Cookbook Name::       elasticsearch
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

node[:elasticsearch][:password_file] = File.join(node[:elasticsearch][:conf_dir], "basicauth.passwd")

ruby_block "create elasticsearch basic_auth file" do
  block do
    $passwords = ::WEBrick::HTTPAuth::Htpasswd.new(node[:elasticsearch][:password_file])
    node[:elasticsearch][:users].each do |user|
      $passwords.set_passwd('Elasticsearch', user[:username], user[:password])
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

template File.join(node[:nginx][:dir], 'conf.d', 'elasticsearch_proxy.conf') do
  source        "elasticsearch_proxy.conf.erb"
  owner         "elasticsearch"
  group         "elasticsearch"
  mode          0644
  variables     ({
    :elasticsearch      => node[:elasticsearch],
  })
end

# ensure proper permissions
file node[:elasticsearch][:password_file] do
  owner node[:nginx][:user]
  group node[:nginx][:user]
  mode 0600
  action :touch
end
