#
# Chef Server Config File
#

supportdir            = '/var/lib/chef'
log_level               :info
log_location            STDOUT
Mixlib::Log::Formatter.show_time = true

chef_server_url        'http://33.33.33.11:4000'

#
# Paths
#
cookbook_path         [ '/var/chef/cookbooks', '/var/chef/site-cookbooks' ]
node_path               '/var/chef/nodes'
role_path               '/var/chef/roles'
umask                   '0022'
#
file_cache_path         '/var/chef/cache'
sandbox_path            '/var/chef/cache/sandboxes'
checksum_path           '/var/lib/chef/cookbook_index'
cookbook_tarball_path   '/var/lib/chef/cookbook-tarballs'

#
# Auth
#
validation_client_name  'chef-validator'
validation_key          '/etc/chef/validation.pem'
client_key              '/etc/chef/client.pem'
#
ssl_verify_mode         :verify_none
signing_ca_cert         '/etc/chef/certificates/cert.pem'
signing_ca_key          '/etc/chef/certificates/key.pem'
signing_ca_user         'chef'
signing_ca_group        'chef'

#
# Web UI options
#
web_ui_admin_user_name  'admin'
web_ui_client_name      'chef-webui'
web_ui_key              '/etc/chef/webui.pem'

#
# Couch
#
couchdb_database        'chef'

#
# Solr
#
solr_url                'http://localhost:8983'
solr_heap_size          '128M'
solr_jetty_path         File.join(supportdir, 'solr', 'jetty')
solr_data_path          File.join(supportdir, 'solr', 'data')
solr_home_path          File.join(supportdir, 'solr', 'home')

#
# Chef's RabbitMQ settings -- http://wiki.opscode.com/display/chef/Chef+Indexer
#
amqp_pass               'testing'
amqp_user               'chef'
amqp_host               '0.0.0.0'
amqp_port               '5672'

# rabbitmqctl add_user           chef testing
# rabbitmqctl add_vhost          /chef
# rabbitmqctl set_permissions -p /chef chef ".*" ".*" ".*"
# rabbitmqctl list_vhosts ; rabbitmqctl list_users ; rabbitmqctl list_user_permissions chef
