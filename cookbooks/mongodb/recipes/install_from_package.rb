include_recipe 'cloud_utils::srp_repo'

daemon_user('mongodb')

if platform_family?('rhel')
  package 'mongo-10gen-server' do
    version "#{node[:mongodb][:version]}-mongodb_1"
  end 
elsif platform_family?('debian')

  package 'mongodb-10gen' do
    options '--force-yes' # Needed for non-GPG chimps apt repository 
    version node[:mongodb][:version]
  end 
end
