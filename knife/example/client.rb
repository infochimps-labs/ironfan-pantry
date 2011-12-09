#
# Configure chef run
#

cluster                "example"
facet                  "sandbox"
facet_index            "0"
chef_server_url        "http://33.33.33.20:4000"

log_level              :info
log_location           STDOUT
node_name              "#{cluster}-#{facet}-#{facet_index}"
validation_client_name "#{cluster}-validator"
validation_key         "/etc/chef/#{cluster}-validator.pem"
client_key             "/etc/chef/client_keys/client-#{node_name}.pem"
environment            "vm_dev"

Chef::Log.info("=> chef client #{node_name} on #{chef_server_url}")
