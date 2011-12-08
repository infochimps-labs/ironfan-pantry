name        'base_role'
description 'top level attributes, applies to all nodes'

run_list *%w[
  build-essential
  motd

  java
  zsh
  ntp
  ]

default_attributes({
    :java => { :install_flavor => 'sun' }, # use sun java typically
  })
