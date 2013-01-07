#
# Cookbook Name:: jenkins_integration
# Recipe:: ironfan_ci
#
# Copyright 2012, Infochimps, Inc.
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

ssh_dir                 = node[:jenkins][:server][:home_dir] + '/.ssh'
directory ssh_dir do
  owner         node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
  mode          '0700'
end

# Set up the correct public key
public_key_filename     = ssh_dir + '/id_rsa'
file public_key_filename do
  owner         node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
  content       node[:jenkins_integration][:ironfan_ci][:deploy_key]
  mode          '0600'
  notifies      :run, 'execute[Regenerate id_rsa.pub]', :immediately
end
execute 'Regenerate id_rsa.pub' do
  user          node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
  cwd           ssh_dir
  command       "ssh-keygen -y -f id_rsa -N'' -P'' > id_rsa.pub"
  action        :nothing
end

# Add Github's fingerprint to known_hosts
cookbook_file ssh_dir + '/github.fingerprint' do
  user          node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
  notifies      :run, 'execute[Get familiar with Github]', :immediately
end
execute 'Get familiar with Github' do
  user          node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
  cwd           ssh_dir
  command       "cat github.fingerprint >> known_hosts"
  action        :nothing
end

# Set up the CI job
jenkins_job 'Ironfan CI' do
  # Remove the indentation of multiline heredoc formatted strings.
  # (Hackity hack, don't talk back.)
  def cleanup_script_format(string='')
    depth = string.gsub(/^( +).+/m,'\1').length
    string.gsub(/^ {#{depth}}/, '')
  end

  knife_shared = cleanup_script_format <<-eos
    export CHEF_USER=#{node[:jenkins_integration][:ironfan_ci][:chef_user]}
    export CLUSTER=#{node[:jenkins_integration][:ironfan_ci][:cluster]}
    export FACET=#{node[:jenkins_integration][:ironfan_ci][:facet]}

    export CREDENTIALS="-x ubuntu -i knife/credentials/ec2_keys/$CLUSTER.pem";

    function knife {
      bundle exec knife "$@"
    }
    function kc {
      knife cluster "$@"
    }
    function klean_exit {
      kc kill $CLUSTER --yes
      exit $@
    }
  eos

  bundler = cleanup_script_format <<-eos
    #!/usr/bin/env bash
    bundle install --path vendor
    bundle update
  eos

  full_sync = cleanup_script_format <<-eos
    #!/usr/bin/env bash
    #{knife_shared}

    cat \<\<EOF > config/Berksfile.conf.rb
    PANTRY_BRANCH='testing'
    ENTERPRISE_BRANCH='testing'
    EOF

    # Would do rake_full install, but that syncs all clusters, too
    rake roles
    rake berkshelf_install
  eos

  pequeno = cleanup_script_format <<-eos
    #!/usr/bin/env bash
    #{knife_shared}

    kc list -f
    kc show $CLUSTER

    kc launch $CLUSTER-$FACET

    while true; do
      kc ssh $CLUSTER $CREDENTIALS cat /var/log/chef/client.log > tmp.client.log
      grep -q 'FATAL: Stacktrace dumped to /var/chef/cache/chef-stacktrace.out' tmp.client.log &&
        kc ssh $CLUSTER $CREDENTIALS sudo cat /var/chef/cache/chef-stacktrace.out &&
        klean_exit 1
      echo "Waiting 5 seconds while chef finishes running" && sleep 5
      grep 'INFO: Chef Run complete in ' tmp.client.log && klean_exit 0
    done
  eos

  repository    node[:jenkins_integration][:ironfan_ci][:repository]
  branches      node[:jenkins_integration][:ironfan_ci][:branches]
  tasks         [ bundler, full_sync, pequeno ]
end

# Setup jenkins user to make commits
template node[:jenkins][:server][:home_dir] + '/.gitconfig' do
  source        '.gitconfig.erb'
  owner         node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
end

# FIXME: fucking omnibus
file node[:jenkins][:server][:home_dir] + '/.profile' do
  content       'export PATH=/opt/chef/embedded/bin/:$PATH'
  owner         node[:jenkins][:server][:user]
  group         node[:jenkins][:server][:group]
end
