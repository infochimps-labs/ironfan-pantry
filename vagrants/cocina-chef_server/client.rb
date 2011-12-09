#
# Configure chef run
#

log_level              :info
log_location           STDOUT
node_name              "cocina-chef_server-0"
chef_server_url        "http://localhost:4000"
validation_client_name "cocina-validator"
validation_key         "/etc/chef/cocina-validator.pem"
client_key             "/etc/chef/client.pem"
json_attribs           "/etc/chef/dna.json"

Chef::Log.info("=> chef client #{node_name} on #{chef_server_url}")
