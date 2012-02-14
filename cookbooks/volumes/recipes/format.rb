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

#
# This tries to have interlocks out the wazoo. Still: caveat coquus
#

volumes(node).each do |vol_name, vol|
  Chef::Log.info(vol.inspect)
  next unless vol.formattable?

  if not vol.ready_to_format? then Chef::Log.info("Skipping format of volume #{vol_name}: not formattable (#{vol.inspect})") ; next ; end

  bash "Format #{vol_name} as #{vol.fstype}" do
    code        "mkfs -t #{vol.fstype} #{vol.device}"
  end

  # don't resize again
  vol.formatted!

end
