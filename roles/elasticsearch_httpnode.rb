name        "elasticsearch_httpnode"
description "Elasticsearch HTTP esnode -- routes HTTP api requests to data nodes."

# List of recipes and roles to apply
run_list(*%w[
  elasticsearch::default
  elasticsearch::install_from_release
  elasticsearch::plugins

  elasticsearch::server
  elasticsearch::load_balancer
  elasticsearch::config_files
])

override_attributes({ :elasticsearch => { :is_httpnode => true },
                      :zabbix        => {
                        :templates   => { :elasticsearch => ["Template_Elasticsearch_Node"] },
                        :host_groups => { :elasticsearch => ["Elasticsearch nodes"]         }
                      }
                    })
