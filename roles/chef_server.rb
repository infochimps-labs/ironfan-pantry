name        "chef_server"
description "Chef server"
run_list(
  "recipe[chef-server::rubygems-install]"
)
default_attributes(
)

override_attributes({
    :users => {
      :chef_client => { :user => 'chef'}

    }
  })
