name        'set_hostname'
description 'Uses route53 to set the machine\'s hostname'

run_list *%w[
  route53::default
  route53::ec2
  ]
