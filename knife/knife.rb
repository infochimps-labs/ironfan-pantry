unless ENV['CHEF_ORGANIZATION'] && ENV['CHEF_USER'] && ENV['CHEF_HOMEBASE']
  Chef::Log.warn("Please set the environment variables CHEF_ORGANIZATION and CHEF_USER \n(to the organization name and user name on your chef server) \nand CHEF_HOMEBASE (to the directory that holds your cookbooks):\n\n    export CHEF_ORGANIZATION=cocina CHEF_USER=chimpy CHEF_HOMEBASE=/cloud\n")
  raise("One or more of $CHEF_ORGANIZATION $CHEF_USER $CHEF_HOMEBASE are unset. Add them to your ~/.bashrc or whatever")
end

organization             ENV['CHEF_ORGANIZATION']
username                 ENV['CHEF_USER']
homebase_dir             ENV['CHEF_HOMEBASE']
knife_dir                File.dirname(__FILE__)

# Clusters, cookbooks and roles
cluster_path             [ "#{homebase_dir}/clusters"  ]
cookbook_path            [ "#{homebase_dir}/cookbooks" ]
role_path                [ "#{homebase_dir}/roles"     ]

# Cloud keypairs -- be sure to `chmod og-rwx -R */*-keys/`
client_key_dir          "#{knife_dir}/#{organization}/client_keys"
ec2_key_dir             "#{knife_dir}/#{organization}/ec2_keys"

log_level                :info
log_location             STDOUT
node_name                username
chef_server_url          "https://api.opscode.com/organizations/#{organization}"
validation_client_name   "#{organization}-validator"
validation_key           "#{knife_dir}/#{organization}/#{organization}-validator.pem"
client_key               "#{knife_dir}/#{organization}/#{username}.pem"
cache_type               'BasicFile'
cache_options            :path => "#{knife_dir}/checksums"

# If you primarily use AWS cloud services:
knife[:ssh_address_attribute] = 'cloud.public_hostname'
knife[:ssh_user]              = 'ubuntu'

# Configure bootstrapping
knife[:bootstrap_runs_chef_client] = true
bootstrap_chef_version   "~> 0.10.4"

def load_if_exists(file) ; load(file) if File.exists?(file) ; end

# Access credentials
load_if_exists "#{knife_dir}/#{organization}/credentials.rb"
# Organization-sepecific settings -- Chef::Config[:ec2_image_info] and so forth
load_if_exists "#{knife_dir}/#{organization}/cloud.rb"
# User-specific knife info or credentials
load_if_exists "#{knife_dir}/knife-user-#{user}.rb"
