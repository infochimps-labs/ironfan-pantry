#
# Configure chef run
#

cluster                "cocina"
facet                  "chef_server"
facet_index            "0"
chef_server_url        "http://localhost:4000"

FileUtils.mkdir_p("/etc/chef/client_keys")

log_level              :info
log_location           STDOUT
node_name              "#{cluster}-#{facet}-#{facet_index}"
validation_client_name "#{cluster}-validator"
validation_key         "/etc/chef/#{cluster}-validator.pem"
client_key             "/etc/chef/client_keys/client-#{node_name}.pem"
environment            "vm_dev"
json_attribs           "/etc/chef/dna.json"

Chef::Log.info("=> chef client #{node_name} on #{chef_server_url}")
