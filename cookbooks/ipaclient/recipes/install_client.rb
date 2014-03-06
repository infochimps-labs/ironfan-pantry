#
# Cookbook Name:: ipaclient
# Recipe:: install_client
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

include_recipe "ipaclient::update_hosts"

package "libnss3-tools"

template "certutil_password" do
  path "#{node['ipaclient']['nsspasswordfile']}"
  source "certutil_password.erb"
  owner "root"
  group "root"
  mode 0644
  variables ({
     :certutil_password => node['ipaclient']['nss_password'],
  })
end

#This sets up script which will update resolv.conf
cookbook_file "#{Chef::Config[:file_cache_path]}/update_resolv.sh" do
        source "update_resolv.sh"
        owner "root"
        group "root"
        mode 0555
        backup false
  not_if { node['ipaclient']['installed'] }
end

remote_directory "/etc/pki/nssdb" do
  owner "root"
  group "root"
  mode 0744
  action :create_if_missing
end

execute "certutil" do
  command "certutil -N -d /etc/pki/nssdb/ -f #{node['ipaclient']['nsspasswordfile']} < /dev/null"
  not_if "test -f /etc/pki/nssdb/cert8.db"
  not_if { node['ipaclient']['installed'] }
end

# We may want to replace this with a saved .deb file
apt_repository "sssd" do
  uri "http://ppa.launchpad.net/sssd/updates/ubuntu/"
  distribution "precise"
  components ["main"]
  key "http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0xB9BF7660CA45F42B"
  action :add
end


apt_repository "freeipa" do
  uri "http://ppa.launchpad.net/freeipa/ppa/ubuntu"
  distribution "precise"
  components ["main"]
  key "http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0x4F48C3EDC98C220F"
  action :add
end

package "openssh-client" do
  version "#{node['ipaclient']['opensshver']}"
  options "--force-yes"
  action :install
end

package "openssh-server" do
  version "#{node['ipaclient']['opensshver']}"
  options "--force-yes"
  action :install
end

package "sssd" do
  options "--force-yes"
  action :install
end
# We may want to replace this with a saved .deb file
# apt_package "freeipa" do
#   source "#{node['ipaclient']['packagepath']}/sssd-ipa_1.11.1-0ubuntu1~precise1_amd64.deb"
#   options "--force-yes"
#   action :add
#  end

package "freeipa-client" do
  options "--force-yes"
  action :install
end
# We may want to replace this with a saved .deb file
# apt_package "freeipa" do
#   source "#{node['ipaclient']['packagepath']}/freeipa-client_3.2.0-0ubuntu1~precise1_amd64.deb"
#   options "--force-yes"
#   action :add
#  end

# Use a saved script, not the one from the deb repo
cookbook_file "ipa-client-install" do
  path "/usr/sbin/ipa-client-install"
  mode 0544
  owner  "root"
  group "root"
  action :create
end

# If we have successfully installed, we dont want to do this one!!!!
execute "client-uninstall" do
  # Need to check here whether we only have the stock version from repo,
  #   which does need to be uninstalled. For idempotency.
  command "ipa-client-install --uninstall || /bin/true"
  not_if "test -f /usr/share/pam-configs/mkhomedir"
  not_if { node['ipaclient']['installed'] }
end

execute "clear-logs" do
  command "/bin/rm /etc/ipa/default.conf"
  only_if "test -f /etc/ipa/default.conf"
  not_if { node['ipaclient']['installed'] }
end

# If we are already in an installed state, the sysrestore stuff might actually
# have useful information
execute "clear-systemrestore" do
  command "/bin/rm /var/lib/ipa-client/sysrestore/*"
  only_if "test -f /var/lib/ipa-client/sysrestore/sysrestore.index"
  not_if { node['ipaclient']['installed'] }
end

# Need to add the nameserver information to the interfaces file
bash "update-resolv" do
  user "root"
  group "root"
  cwd "#{Chef::Config[:file_cache_path]}"
  code <<-EOH
   export DOMAIN="#{node.default['ipaclient']['domain']}"
   export SERVER0="#{node.default['ipaclient']['ns'][0]}"
   export SERVER1="#{node.default['ipaclient']['ns'][1]}"
   export SERVER2="#{node.default['ipaclient']['ns'][2]}"
   export SERVER3="#{node.default['ipaclient']['ns'][3]}"
   "#{Chef::Config[:file_cache_path]}/update_resolv.sh"
  EOH
  not_if { node['ipaclient']['installed'] }
end

execute "name-resolution" do
  command "echo dns-search #{node['ipaclient']['domain']} >> /etc/network/interfaces; echo dns-nameservers #{node['ipaclient']['masterip']}  >> /etc/network/interfaces"
  not_if "/bin/grep $#{node['ipaclient']['masterip']} /etc/network/interfaces"
  not_if { node['ipaclient']['installed'] }
end

execute "set-domain" do
  command "domainname #{node['ipaclient']['domain']}"
  not_if { node['ipaclient']['installed'] }
end

# This has to happen inside ruby_block so it's evaluated at execute time
ruby_block "client-install" do
  block do
    # Set up the encrypted data bag
    fqhostname = [`cat /etc/hostname`, "#{node['ipaclient']['domain']}"].compact.join('.')
    system "yes 'yes'|ipa-client-install --server=#{[node['ipaclient']['masterhostname'], node['ipaclient']['domain']].compact.join('.')} --domain=#{node['ipaclient']['domain']} --realm=#{node['ipaclient']['domain'].upcase()} --noac --enable-dns-updates --no-ntp --hostname=#{fqhostname} --mkhomedir --password=#{node['ipaclient']['admin_secret']} --principal=#{node['ipaclient']['admin_principal']}"
  end
  not_if { node['ipaclient']['installed'] }
end

cookbook_file "/etc/ssh/sshparams.sh" do
        source "sshparams.sh"
        owner "root"
        group "root"
        mode 0555
        backup false
  not_if { node['ipaclient']['installed'] }
end

bash "update_config_files" do
  user "root"
  group "root"
  cwd "/etc/ssh"
  code <<-EOH
  export IFACE=eth0
  /etc/ssh/sshparams.sh
  EOH
  not_if { node['ipaclient']['installed'] }
end

execute "sudo-ldap-install" do
  # You have to specify the environent var here or else the package install will fail
  command "export SUDO_FORCE_REMOVE=yes; apt-get install -y sudo-ldap; export SUDO_FORCE_REMOVE=no"
  not_if { node['ipaclient']['installed'] }
end

template "/etc/nsswitch.conf" do
  source "nsswitch.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

template "/etc/ldap/ldap.conf" do
  source "sudo-ldap.conf.erb"
  owner "root"
  group "root"
  mode 0644
  action :create
  variables ({
     :ldapbase => "dc=#{node['ipaclient']['domain'].split('.').join(",dc=")}",
     :bindpw => node['ipaclient']['nss_password'],
     :ldap_url=> "ldap://#{node['ipaclient']['masterhostname']}.#{node['ipaclient']['domain']}"
  })
end

cookbook_file "mkhomedir" do
  path "/usr/share/pam-configs"
  action :create_if_missing
  mode 0644
end

execute "pam-auth-update" do
  command "/usr/sbin/pam-auth-update --package --force"
  not_if { node['ipaclient']['installed'] }
end


ruby_block "mark ipaclient as installed" do
 block do
    node.default['ipaclient']['installed'] = true
    node.save
  end
  not_if { node['ipaclient']['installed'] }
end
