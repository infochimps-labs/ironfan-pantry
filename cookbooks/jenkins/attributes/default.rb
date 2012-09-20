#
# Cookbook Name:: jenkins
# Based on hudson
# Attributes:: default
#
# Author:: Doug MacEachern <dougm@vmware.com>
# Author:: Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2010, VMware, Inc.
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
# Services
#

default[:jenkins][:server ][:run_state] = :start
default[:jenkins][:worker ][:run_state] = :start

#
# Locations
#

default[:jenkins][:conf_dir]            = "/etc/jenkins"
default[:jenkins][:log_dir]             = "/var/log/jenkins"
default[:jenkins][:lib_dir]             = "/var/lib/jenkins"
default[:jenkins][:pid_dir]             = "/var/run/jenkins"

case node[:platform]
when /mac_os_x/
  default[:jenkins][:server][:home_dir] = "/Users/Shared/Jenkins"
  default[:jenkins][:worker][:home_dir] = "/Users/Shared/Jenkins"
  default[:jenkins][:install_dir]       = "/usr/local/lib"

  server_username = "_jenkins"
  worker_username = "_jenkins"
  group_name      = "_jenkins"

  default[:rbenv][:default_ruby]        = '1.9.3-p0'
  default[:rbenv][:rubies]['1.9.3-p0']  = ''
  default[:jenkins][:worker][:shell]    = '/usr/local/bin/bash'

else
  default[:jenkins][:server][:home_dir] = "/var/lib/jenkins"
  default[:jenkins][:worker][:home_dir] = "/var/lib/jenkins_worker"
  default[:jenkins][:install_dir]       = "/usr/share/jenkins"
  default[:jenkins][:worker][:shell]    = "/bin/bash"

  server_username = "jenkins"
  worker_username = "jenkins_worker"
  group_name      = "jenkins"
end


[ :install_dir, :log_dir, :pid_dir, :conf_dir ].each do |dir|
  default[:jenkins][:server][dir] = default[:jenkins][dir]
  default[:jenkins][:worker][dir] = default[:jenkins][dir]
end

default[:jenkins][:server][:user]     = server_username
default[:jenkins][:server][:group]    = group_name
default[:jenkins][:worker][:user]     = worker_username
default[:jenkins][:worker][:group]    = group_name

default[:users ][worker_username][:uid] = 361
default[:users ][server_username][:uid] = 360
default[:groups][group_name     ][:gid] = 360

# address for the host to bind to (default to all addresses)
default[:jenkins][:server][:host]       = '0.0.0.0'
# port for HTTP connector (default 8080; disable with -1)
default[:jenkins][:server][:port]       = 8080
# port for AJP connector (disabled by default)
default[:jenkins][:server][:ajp_port]   = -1

default[:jenkins][:worker][:name]       = node.name

#
# Install
#

# working around: http://tickets.opscode.com/browse/CHEF-1848; set to true if you have the CHEF-1848 patch applied
default[:jenkins][:server][:use_head]   = false

default[:jenkins][:apt_mirror]          = "http://pkg.jenkins-ci.org/debian"
default[:jenkins][:plugins_mirror]      = "http://updates.jenkins-ci.org"

#download the latest version of plugins, bypassing update center
#example: ["git", "URLSCM", ...]
default[:jenkins][:server][:plugins]    = %w[ notification ]

#
# Integration
#

default[:jenkins][:iptables_allow]      = "enable"

#
# Description
#

#"Description"
default[:jenkins][:worker][:description] =
  "#{node[:platform]} #{node[:platform_version]} " <<
  "[#{node[:kernel][:os]} #{node[:kernel][:release]} #{node[:kernel][:machine]}] " <<
  "worker on #{node[:hostname]}"
#"Labels"
default[:jenkins][:worker][:labels]     = (node[:tags] || []).join(" ")

#
# SSH worker options
#

default[:jenkins][:worker][:ssh_host]   = node[:fqdn]
default[:jenkins][:worker][:ssh_port]   = 22
default[:jenkins][:worker][:ssh_user]   = default[:jenkins][:worker][:user]
default[:jenkins][:worker][:ssh_pass]   = nil
default[:jenkins][:worker][:jvm_options] = nil
#jenkins master defaults to: "#{ENV['HOME']}/.ssh/id_rsa"
default[:jenkins][:worker][:ssh_private_key] = nil

#
# HTTP frontend
#

default[:jenkins][:http_proxy][:variant]              = nil
default[:jenkins][:http_proxy][:www_redirect]         = "disable"
default[:jenkins][:http_proxy][:listen_ports]         = [ 80 ]
default[:jenkins][:http_proxy][:host_name]            = nil
default[:jenkins][:http_proxy][:host_aliases]         = []
default[:jenkins][:http_proxy][:client_max_body_size] = "1024m"
