
environment=node[:cloud_utils][:srp][:environment]

apt_repository 'srp-debian' do
  uri "https://s3.amazonaws.com/srp-debian.chimpy.us/#{environment}/"
  distribution '/'
  action :add
  notifies :run, "execute[apt-get update]", :immediately
end
