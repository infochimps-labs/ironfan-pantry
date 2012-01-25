ClusterChef.cluster 'elasticsearch_demo' do
  cloud(:ec2) do
    defaults
    availability_zones ['us-east-1d']
    flavor              'm1.xlarge'
    backing             'ebs'
    image_name          'cluster_chef-natty'
    bootstrap_distro    'ubuntu10.04-cluster_chef'
    chef_client_script  'client.rb'
    mount_ephemerals(:tags => { :elasticsearch_scratch => true })
  end

  environment           :prod

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

  facet :elasticsearch do
    instances           1
    recipe              'volumes::build_raid', :first
    recipe              'tuning'
    #
    recipe              'elasticsearch::default'
    recipe              'elasticsearch::install_from_release'
    recipe              'elasticsearch::install_plugins'
    recipe              'elasticsearch::server'

    cloud.mount_ephemerals
    raid_group(:md0) do
      device            '/dev/md0'
      mount_point       '/raid0'
      level             0
      sub_volumes       [:ephemeral0, :ephemeral1, :ephemeral2, :ephemeral3]
    end
  end

end
