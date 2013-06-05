include_recipe 'route53::default'

aws      = node[:aws]
dns_name = node[:cube][:evaluator][:dns_name]

if aws && aws[:aws_access_key_id] && aws[:aws_secret_access_key] && dns_name
  dns_zone = node[:cube][:evaluator][:dns_zone] || dns_name.slice(/\.(.+)/,1) # Assume zone is direct parent
  route53_rr(dns_name) do
    zone          dns_zone

    fqdn          dns_name
    type          "A"
    values        [ node[:public_ip] ]
    ttl           node[:route53][:ttl]

    action        :update
    aws_access_key_id     aws[:aws_access_key_id]
    aws_secret_access_key aws[:aws_secret_access_key]
  end
elsif dns_name.nil?
  Chef::Log.warn("Cannot set DNS entry, because we have no name to use: set node[:cube][:evaluator][:dns_name]")
else
  Chef::Log.warn("Cannot set DNS entry, because we have no AWS credentials: set node[:aws][:aws_access_key_id] and node[:aws][:aws_secret_access_key]")
end