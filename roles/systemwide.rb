name        'systemwide'
description 'top level attributes, applies to all nodes'

run_list *%w[
  build-essential
  motd
  zsh
  emacs
  ntp
  ]

default_attributes({
  :java        => { # use oracle java
    :install_flavor => 'oracle',
    :jdk => { 6 => { :x86_64 => { 
      :url        => 'http://artifacts.chimpy.us.s3.amazonaws.com/tarballs/jdk-6u32-linux-x64.bin',
      :checksum   => '269d05b8d88e583e4e66141514d8294e636f537f55eb50962233c9e33d8f8f49'
      } } }
  },
})
