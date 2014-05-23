include_recipe 'cloud_utils::srp_repo'

daemon_user 'kafka'

package node[:kafka][:package_name] do
  version node[:kafka][:version]
end

include_recipe 'kafka::install_common'
