#
# Cookbook Name::       silverware
# Description::         Base configuration for silverware
# Recipe::              default
# Author::              Philip (flip) Kromer
#
# Copyright 2011, Philip (flip) Kromer
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

standard_dirs('silverware') do
  directories   :conf_dir, :log_dir, :home_dir
end

# FIXME: Announce once used node.set instead of node.default, resulting
#  in announcements that persisted even after the announcing cookbook
#  was removed from the run-list. This removes those stale values; once
#  it has been run everywhere in the organization, it is safe to remove.
# Since it is not inherently dangerous, I recommend leaving it in place
#  until silverware v4.
node.normal_attrs.delete(:announces)

announce(:silverware, :default)

# Silverware log storage on a single scratch dir
volume_dirs('silverware.log') do
  type          :local
  selects       :single
  path          'silverware/log'
  group         'root'
  mode          "0777"
end
link "/var/log/silverware" do
  to node[:silverware][:log_dir]
end