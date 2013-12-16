#
# Cookbook Name:: jenkins_integration
# Recipe:: cookbook_ci
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

cookbook_ci = node[:jenkins_integration][:cookbook_ci]

# # Make sure that the test homebase is the first homebase
# # FIXME: This breaks for obscure attribute interface reasons
# node.set[:jenkins_integration][:cookbook_ci][:homebases] = (
#   node[:jenkins_integration][:cookbook_ci][:homebases].unshift
#   node[:jenkins_integration][:cookbook_ci][:test_homebase] ).uniq

shared_templates = %w[ shared.inc launch.sh cookbook_versions.rb.h ]
# Advance changes into testing positions, or bomb if no changes
# jenkins_job "Ironfan Cookbooks - 1 - Prepare testing" do
#   pantries      cookbook_ci[:pantries]
#   homebases     cookbook_ci[:homebases]
#   templates     shared_templates
#   tasks         %w[ checkout.sh enqueue_tests.sh ]
#   triggers      :schedule => cookbook_ci[:schedule]
#   conditional   :regexp => "SUCCESS:",
#                 :target => "Ironfan Cookbooks - 2 - Test and stage"
#   retention     :days => 14
# end

# Launch a testing server and push testing into staging if successful
# jenkins_job "Ironfan Cookbooks - 2 - Test and stage" do
#   pantries      cookbook_ci[:pantries]
#   homebases     cookbook_ci[:homebases]
#   templates     shared_templates
#   tasks         %w[ checkout.sh launch_instances.sh stage_all.sh ]
#   retention     :days => 14
#   if cookbook_ci[:broken]
#     downstream  [ "Ironfan Cookbooks - 3 - Test known broken" ]
#   end
# end

# Launch a known broken instance
# if cookbook_ci[:broken]
#   jenkins_job "Ironfan Cookbooks - 3 - Test known broken" do
#     homebases           [ cookbook_ci[:test_homebase] ]
#     templates           shared_templates
#     tasks               %w[ checkout.sh launch_broken.sh ]
#     retention           :days => 14
#   end
# end

# On an existing host, converge and run ironcuke
jenkins_job "Converge and ironcuke existing host" do
  pantries      cookbook_ci[:pantries]
  homebases     cookbook_ci[:homebases]
  templates     shared_templates
  tasks         %w[ checkout.sh run_ironcuke.sh ]
  retention     :days => 3
  triggers      :schedule => cookbook_ci[:cuke_schedule]
end

