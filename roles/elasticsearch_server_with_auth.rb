name        "elasticsearch_server_with_auth"
description "Elasticsearch server: holds and indexes data, and replies to http requests. plug nginx reverse proxy for basic auth"

# FIXME: Apparently this will not ensure order. not sure how to do
# this, but nginx must be run after
# elasticsearch::basic_auth. (Actually, they are codependents.)

# List of recipes and roles to apply
run_list(*%w[
  role[elasticsearch_datanode]
  elasticsearch::basic_auth
  nginx
  role[elasticsearch_httpnode]
])
