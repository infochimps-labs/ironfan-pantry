#
# Cookbook Name::       volumes
# Description::         Format the volumes listed in node[:volumes]
# Recipe::              format
# Author::              Philip (flip) Kromer - Infochimps, Inc
#
# Copyright 2011, Philip (flip) Kromer - Infochimps, Inc
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

# mkfs.xfs requires a -f option to be passed in when formatting over
# an existing file system.
mkfs_options = { "xfs" => "-f" }


volumes(node).each do |vol_name, vol|
  Chef::Log.info(vol.inspect)
  next unless vol.formattable?

  if not vol.ready_to_format? then Chef::Log.info("Skipping format of volume #{vol_name}: not formattable (#{vol.inspect})") ; next ; end


  format_filesystem = execute "/sbin/mkfs -t #{vol.fstype} #{mkfs_options[vol.fstype].to_s} #{vol.device} -L #{vol.name}" do
    not_if "eval $(blkid -o export #{vol.device}); test $TYPE = '#{vol.fstype}'"
    action  :nothing
  end

  format_filesystem.run_action(:run)
  
  # don't even think about formatting again
  vol.formatted!

end
