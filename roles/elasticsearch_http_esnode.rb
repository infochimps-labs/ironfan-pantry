name        "elasticsearch_http_esnode"
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
