#
# Cookbook Name::       volumes
# Description::         Mount the volumes listed in node[:volumes]
# Recipe::              mount
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

# defined in volumes/libraries/volumes.rb
volumes.each do |vol_name, vol|
  next unless vol.mountable?

  if not vol.attached?
    Chef::Log.info "Before mounting, you must attach the #{vol_name} volume at #{vol.device}"
    next
  end

  directory vol.mount_point do
    recursive   true
    owner       vol.owner
    group       vol.owner
  end

  #
  # If you mount multiple cloud volumes from the same snapshot, you may get an
  #   'XFS: Filesystem xvdk has duplicate UUID - can't mount'
  # error (check `sudo dmesg | tail`).
  #
  # If so, read http://linux-tips.org/article/50/xfs-filesystem-has-duplicate-uuid-problem
  #

  mount vol['mount_point'] do
    device      vol.device
    fstype      vol.fstype
    options     vol.mount_options if vol.mount_options
    dump        vol.mount_dump    if vol.mount_dump
    fsck        vol.mount_fsck    if vol.mount_fsck
    device_type vol.device_type   if vol.device_type
    only_if{ vol.attached? }
    action      [:mount]
  end

end
