name        'jenkins_master'
description 'installs the jenkins master server'

run_list *%w[
  jenkins
  jenkins::server
  jenkins::user_key
  jenkins::node_ssh
  jenkins::build_from_github
  jenkins::build_ruby_rspec
  jenkins::plugins
  ]
