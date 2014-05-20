
environment=node[:cloud_utils][:srp][:environment]

if platform_family?('debian')
    apt_repository 'srp-debian' do
      uri "https://s3.amazonaws.com/srp-debian.chimpy.us/#{environment}/"
      distribution '/'
      action :add
      notifies :run, "execute[apt-get update]", :immediately
    end
elsif platform_family?('rhel')
      yum_repository "srp-rhel" do
        name "infochimps-#{environment}"
        url "https://s3.amazonaws.com/srp-rhel.chimpy.us/#{environment}/"
        # key "RPM-GPG-KEY-chimps"
        action :add
      end
end
