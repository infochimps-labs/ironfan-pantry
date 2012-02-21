name        "elasticsearch_server"
description "Elasticsearch server: holds and indexes data, and replies to http requests."

# List of recipes and roles to apply
run_list(*%w[
  role[elasticsearch_datanode]
  role[elasticsearch_httpnode]
])
