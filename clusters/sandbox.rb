#
# Sandbox cluster -- use this for general development
#
ClusterChef.cluster 'sandbox' do
  cloud(:ec2) do
    defaults
    availability_zones ['us-east-1d']
    flavor              't1.micro'
    backing             'ebs'
    image_name          'cluster_chef-natty'
    bootstrap_distro    'ubuntu10.04-cluster_chef'
    chef_client_script  'client.rb'
    mount_ephemerals
  end

  environment           :dev

  role                  :base_role
  role                  :chef_client
  role                  :ssh
  role                  :nfs_client

  role                  :volumes
  role                  :package_set, :last
  role                  :dashboard,   :last

  role                  :org_base
  role                  :org_final, :last
  role                  :org_users

  facet :korny do
    instances           1
  end

  facet :mrflip do
    instances           1
  end

  cluster_role.override_attributes({
    })
end
