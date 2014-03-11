include_recipe 'cloud_utils::srp_apt_repo'

daemon_user 'kafka'

package 'kafka' do
  options '--force-yes' # Needed for non-GPG chimps repository
  version node[:kafka][:version]
end

include_recipe 'kafka::install_common'
