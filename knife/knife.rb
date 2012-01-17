#
# organization - selects your cloud environment.
# username     - selects your client key and user-specific overrides
# homebase     - default location for clusters, cookbooks and so forth
#
organization        ENV['CHEF_ORGANIZATION']
username            ENV['CHEF_USER']
homebase            File.expand_path(ENV['CHEF_HOMEBASE'])

unless organization && username && homebase
  Chef::Log.warn %Q{Please set these environment variables:\n\n* CHEF_ORGANIZATION (got '#{organization}') chef server organization name\n* CHEF_USER         (got '#{username}') chef server username\n* CHEF_HOMEBASE     (got '#{homebase}') folder holding cookbooks/, roles/, etc dirs\n\n}
  # add a line like this to your ~/.bashrc or whatever: export CHEF_ORGANIZATION=cocina CHEF_USER=chimpy CHEF_HOMEBASE=~/homebase
  raise("One of the CHEF_ORGANIZATION, CHEF_USER, or CHEF_HOMEBASE environment variables is missing.")
end

$LOAD_PATH.unshift(File.join(homebase, "vendor/cluster_chef/lib")) if File.exists?(File.join(homebase, "vendor/cluster_chef/lib"))

#
# Clusters, cookbooks and roles
#
cluster_path        [ "#{homebase}/clusters"  ]
cookbook_path       [ "#{homebase}/cookbooks", "#{homebase}/site-cookbooks" ]
role_path           [ "#{homebase}/roles"     ]

#
# Keys and cloud-specific settings.
# Be sure all your .pem files are non-readable (mode 0600)
#
credentials_path    File.expand_path("#{organization}-credentials", File.dirname(__FILE__))
client_key_dir      "#{credentials_path}/client_keys"
ec2_key_dir         "#{credentials_path}/ec2_keys"

#
# Load the vendored cluster_chef lib if present
#
if File.exists?("#{homebase}/vendor/cluster_chef/lib")
  $LOAD_PATH.unshift("#{homebase}/vendor/cluster_chef/lib")
end

log_level               :info
log_location            STDOUT
node_name               username
chef_server_url         "https://api.opscode.com/organizations/#{organization}"
client_key              "#{credentials_path}/#{username}.pem"
cache_type              'BasicFile'
cache_options           :path => "/tmp/chef-checksums-#{username}"
validation_key          "#{credentials_path}/#{organization}-validator.pem"
validation_client_name  "#{organization}-validator"

#
# Configure client bootstrapping
#
bootstrap_runs_chef_client true
bootstrap_chef_version  "~> 0.10.4"

#
# Additional settings and overrides
#

def load_if_exists(file) ; load(file) if File.exists?(file) ; end

# Organization-sepecific settings -- Chef::Config[:ec2_image_info] and so forth
load_if_exists "#{credentials_path}/knife-org.rb"
# User-specific knife info or credentials
load_if_exists "#{credentials_path}/knife-user-#{username}.rb"
