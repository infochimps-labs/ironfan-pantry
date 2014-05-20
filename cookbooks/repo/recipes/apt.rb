#
# Cookbook Name::       repo
# Description::         Sets up apt repository
# Recipe::              default
# Author::              Brandon Bell - Infochimps, Inc
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

if platform_family? "debian" then

package 'reprepro'

  directory node[:repo][:apt][:base] do
    owner	"root"
    group	"root"
    mode	0755
    action :create
  end
  
  %w{conf db dists incoming indices logs pool project tmp}.each do |dir|
    directory "#{node[:repo][:apt][:base]}/#{dir}" do
      mode	"0755"
      owner	"root"
      group	"root"
      action :create
    end
  end
  
  template "#{node[:repo][:apt][:base]}/conf/distributions" do
    source "deb.distributions.erb"
    mode 0644
  end
  
  template "#{node[:repo][:apt][:base]}/conf/options" do
    source "deb.options.erb"
    mode 0644
  end
  
  template "#{node[:repo][:apt][:base]}/conf/updates" do
    source "deb.updates.erb"
    mode 0644
  end
  
  cron "apt sync" do
    minute        node[:repo][:apt][:minute]
    hour          node[:repo][:apt][:hour]
    day           node[:repo][:apt][:day]
    month         node[:repo][:apt][:month]
    weekday       node[:repo][:apt][:weekday]
    command       "reprepro -b #{node[:repo][:apt][:base]} update > /tmp/apt-repo-sync.out 2>&1"
  end
  
  execute "run apt sync" do 
    command	"reprepro -b #{node[:repo][:apt][:base]} update > /tmp/apt-repo-sync.out 2>&1"
    action :run
  end

end

