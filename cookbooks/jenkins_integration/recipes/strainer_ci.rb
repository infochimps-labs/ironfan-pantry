#
# Cookbook Name:: jenkins_integration
# Recipe:: strainer_ci
#
# Copyright 2013, Infochimps, Inc.
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

if node[:jenkins_integration][:strainer][:notification] == true
  %w[sendEmail libio-socket-ssl-perl libnet-ssleay-perl].each { |name| package(name) }
  %w[from server port username password].each do |prop|
    value = node.jenkins_integration.smtp.send(prop) rescue nil
    Chef::Log.warn("#{value} is blank; Jenkins server will not be able to send email.") if value.nil?
  end
end

shared_templates = %w[ shared.inc sendmail.sh launch.sh ]
# Kick off independent Strainer tests to progress independent cookbooks
jenkins_job "Ironfan Pantry - 0 - Prestrain" do
  templates     shared_templates
  retention     :total => 30 
  triggers      :schedule => node[:jenkins_integration][:strainer][:schedule]
  tasks         %w[ pre-strain.sh ]
end

jenkins_job "Ironfan Pantry - 1 - Strain" do
  templates     shared_templates
  retention     :total => 60 
  triggers      :token => "#{node[:jenkins_integration][:strainer][:token]}"
  parameters    :cookbook => { :type => 'string' }
  tasks         %w[ strain.sh ]
end

jenkins_job "Ironfan Pantry - 2 - Converge and Test" do
  templates     shared_templates
  retention     :total => 30
  triggers      :token => "#{node[:jenkins_integration][:strainer][:token]}"
  parameters    :cookbook => { :type => 'string' }
  tasks         %w[ converge.sh ]
end
