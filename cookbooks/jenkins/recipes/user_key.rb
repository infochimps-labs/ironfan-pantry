#
# Cookbook Name::       jenkins
# Description::         User Key
# Recipe::              user_key
# Author::              Fletcher Nichol
#
# Copyright 2011, Fletcher Nichol
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

public_key_filename = "#{node[:jenkins][:server][:home_dir]}/.ssh/id_rsa"

directory File.dirname(public_key_filename) do
  owner         node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
  mode          "0700"
  recursive     true
  action        :create
end

ruby_block "record jenkins ssh public_key" do
  block{        node.set[:jenkins][:server][:public_key] = File.open("#{public_key_filename}.pub") { |f| f.gets } }
  action        :nothing
end

execute "ssh-keygen -f #{public_key_filename} -N ''" do
  user          node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
  notifies      :create, 'ruby_block[record jenkins ssh public_key]', :immediately
  not_if{ File.exists?(public_key_filename) }
end

announce(:jenkins, :ssher,
  :user       => node[:jenkins][:server][:user],
  :public_key => node[:jenkins][:server][:public_key] )
