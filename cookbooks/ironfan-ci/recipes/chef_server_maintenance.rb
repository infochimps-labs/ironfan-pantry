
# FIXME: use discovery (localhost is hardcoded)

bash "lower chef-server couchdb revision limit" do
  code     <<EOF
curl -X PUT -d 200 http://localhost:5984/chef/_revs_limit
EOF
end

bash "compact chef-server couchdb" do
  code     <<EOF
curl -H "Content-Type: application/json" -X POST http://localhost:5984/chef/_compact
curl -H "Content-Type: application/json" -X POST http://localhost:5984/chef/_view_cleanup
EOF
end
