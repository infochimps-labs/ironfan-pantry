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
    role                :hadoop_s3_keys
    recipe 'route53::default'
    recipe 'route53::ec2'
  end

  facet :raid_demo do
    instances           1
    cloud.flavor        'c1.xlarge'
    recipe              'volumes::build_raid', :first

    cloud.mount_ephemerals
    raid_group(:md0) do
      device            '/dev/md0'
      mount_point       '/raid0'
      level             0
      sub_volumes       [:ephemeral0, :ephemeral1, :ephemeral2, :ephemeral3]
    end
  end

  cluster_role.override_attributes({
    })
end
