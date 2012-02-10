name        'set_domain_name'
description 'Uses route53 to set the machine\'s domain name'

run_list *%w[
  route53::default
  route53::ec2
  ]
