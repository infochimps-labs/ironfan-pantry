name        "chef_server"
description "Chef server"
run_list(
  "recipe[chef-server::rubygems-install]"
)
