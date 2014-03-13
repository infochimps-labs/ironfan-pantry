include_recipe 'cloud_utils::srp_apt_repo'

package 'mongodb-10gen' do
  options '--force-yes' # Needed for non-GPG chimps repository
  version node[:mongodb][:version]
end
