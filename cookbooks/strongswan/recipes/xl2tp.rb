#
# Cookbook Name:: strongswan
# Description:: Installs l2tp ipsec support for StrongSwan server.
# Recipe:: xl2tp
# Author:: Jerry Jackson (<jerry.w.jackson@gmail.com>)
#
# Copyright 2012, Infochimps
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

include_recipe "strongswan::ipsec"

# install xl2tpd from package
package "xl2tpd"

# xl2tpd service definition
service "xl2tpd" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

# manipulate various config files to do our bidding
%w{ /etc/xl2tpd/xl2tpd.conf
    /etc/ppp/options.xl2tpd
    /etc/ppp/chap-secrets
}.each do |fname|
  template fname do
    source "l2tp-nat/#{File.basename(fname)}.erb"
    notifies :reload, "service[xl2tpd]", :delayed
  end
end
announce( :strongswan, :xl2tpd )

# set up the ipsec scenario
node[:strongswan][:scenarios] << "l2tp-nat"
