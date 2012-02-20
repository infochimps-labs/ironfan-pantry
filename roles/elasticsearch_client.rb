name        "elasticsearch_client"
description "Client for an elasticsearch cluster: doesn't run daemons, just installs and configures."

# List of recipes and roles to apply
run_list(*%w[
  elasticsearch::default
  elasticsearch::install_from_release
  elasticsearch::plugins

  elasticsearch::client
  elasticsearch::config_files
])
