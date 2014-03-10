#
# Cookbook Name:: ipaclient
# Recipe:: default
#
# Copyright 2014, Infochimps, a CSC Big Data Business
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

default['ipaclient']['nsspasswordfile'] = "#{Chef::Config[:file_cache_path]}/password"
default['ipaclient']['admin_secret'] = "srp admin password"
default['ipaclient']['admin_principal'] = "srp admin username"
default['ipaclient']['domain'] = 'ipa.chimpy.us'
default['ipaclient']['masterhostname'] = 'ipamaster'
default['ipaclient']['opensshver'] = "1:6.2p2-3~precise2"
default['ipaclient']['ns'] = ['ns-253.awsdns-31.com',
                              'ns-1408.awsdns-48.org',
                              'ns-1799.awsdns-32.co.uk',
                              'ns-539.awsdns-03.net'
                             ]
default['ipaclient']['installed'] = false
