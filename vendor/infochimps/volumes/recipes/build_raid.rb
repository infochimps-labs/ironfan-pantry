#
# Cookbook Name::       volumes
# Description::         Build a raid array of volumes as directed by node[:volumes]
# Recipe::              build_raid
# Author::              Chris Howe
#
# Copyright 2011, Infochimps
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

include_recipe 'xfs'

#
# install mdadm immediately
#
package('mdadm'){ action :nothing }.run_action(:install)

#
# Assemble raid groups using volumes defined in node metadata -- see volumes/libraries/volumes.rb
#
Metachef.raid_groups(node).each do |rg_name, rg|

  sub_vols = sub_volumes(node, rg)

  Chef::Log.info(rg.inspect)
  Chef::Log.info( sub_vols.values.inspect )

  #
  # unmount all devices tagged for that raid group
  #
  sub_vols.each do |_, sub_vol|
    mount sub_vol.mount_point do
      device sub_vol.device
      action [:umount, :disable]
    end
  end

  #
  # Create the raid array
  #
  mdadm(rg.device) do
    devices   sub_vols.values.map(&:device)
    level     0
    action    [:create, :assemble]
  end

  # # Scan
  # File.open("/etc/mdadm/mdadm.conf", "a") do |f|
  #   f << "DEVICE #{parts.join(' ')}\n"
  #   f << `mdadm --examine --scan`
  # end
  #
  # bash "set read-ahead" do
  #   code      "blockdev --setra #{raid_group.read_ahead} #{raid_group.device}"
  # end

  if rg.formattable?
    if rg.ready_to_format?
      bash "format #{rg.name} (#{rg.sub_volumes})" do
        user      "root"
        # Returns success iff the drive is formatted XFS
        code      %Q{ mkfs.xfs -f #{rg.device} ; file -s #{rg.device} | grep XFS }
        not_if("file -s #{rg.device} | grep XFS")
      end
      rg.formatted!
    else
      Chef::Log.warn("Not formatting #{rg.name}. Volume is unready: (#{rg.inspect})")
    end
  end


end
