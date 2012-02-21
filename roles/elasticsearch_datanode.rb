name        "elasticsearch_datanode"
description "Elasticsearch Datanode (holds and indexes data) for elasticsearch cluster."

# List of recipes and roles to apply
run_list(*%w[
  elasticsearch::default
  elasticsearch::install_from_release
  elasticsearch::plugins

  elasticsearch::server
  elasticsearch::config_files
])

override_attributes({ :elasticsearch => { :is_datanode => true } })
