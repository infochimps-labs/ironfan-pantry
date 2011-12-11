#
# Configure chef run
#

dna_file = '/etc/chef/dna.json'
dna_file_missing  = 'The file /etc/chef/dna.json must contain at least the keys "cluster_name", "facet_name", "facet_index" and "chef_server_url"'

raise dna_file_missing unless File.exists?(dna_file)
chef_config = JSON.parse(File.read(dna_file))

cluster_name            chef_config['cluster_name']
facet_name              chef_config['facet_name']
facet_index             chef_config['facet_index']
chef_server_url         chef_config['chef_server_url']

raise dna_file_missing if [cluster_name, facet_name, facet_index, chef_server_url].any?{|x| x.to_s.empty? }

log_level               :info
log_location            STDOUT
node_name               "#{cluster_name}-#{facet_name}-#{facet_index}"
validation_client_name  "#{cluster_name}-validator"
validation_key          "/etc/chef/#{cluster_name}-validator.pem"
client_key              "/etc/chef/client_keys/client-#{node_name}.pem"
environment             "vm_dev"
json_attribs            "/etc/chef/dna.json"

FileUtils.mkdir_p(File.dirname(client_key))
Chef::Log.debug(chef_config.reject{|k| k.to_s =~ /_key$/})
Chef::Log.info("=> chef client #{node_name} on #{chef_server_url}")
