name        'jenkins_master'
description 'installs the jenkins master server'

run_list *%w[
  jenkins::default
  jenkins::server
  jenkins::user_key
  jenkins::node_ssh
  jenkins::osx_worker
  jenkins::build_from_github
  jenkins::build_ruby_rspec
  jenkins::auth_github_oauth
  jenkins::plugins
  ]

# FIXME: these are for OSX. move to right place
default_attributes({

    :rbenv => {
      :default_ruby => '1.9.3-p0',
      :rubies       => { '1.9.3-p0' => '', },
    },
    :jenkins => {
      :worker => { :shell => '/usr/local/bin/bash' },
    },
})
