define :assign_dns_name do

  server_type = params[:name]
  dns_name    = node[:package_server][server_type][:dns_prefix]
  aws         = node[:aws]
  fqdn        = [dns_name, node[:route53][:zone]].compact.join('.')
  
  if dns_name && aws && aws[:aws_access_key_id] && aws[:aws_secret_access_key] && node[:cloud]

    route53_rr dns_name do
      zone                  node[:route53][:zone]
      fqdn                  fqdn
      type                  'CNAME'
      values                ["#{node[:cloud][:public_hostname]}."]
      ttl                   node[:route53][:ttl]
      action                :update
      aws_access_key_id     aws[:aws_access_key_id]
      aws_secret_access_key aws[:aws_secret_access_key]
    end

    node[:package_server][server_type][:fqdn] = fqdn

  elsif not node[:cloud]
    Chef::Log.warn("Cannot set hostname, because the node[:cloud] attributes aren't set. On a cloud machine, sometimes this doesn't happen until the second run.")
  else
    Chef::Log.warn("Cannot set hostname, because we have no AWS credentials: set node[:aws][:aws_access_key_id] and node[:aws][:aws_secret_access_key]")
  end

end
