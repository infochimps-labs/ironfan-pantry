ClusterChef.cluster 'elasticsearch_demo' do
  cloud :ec2 do
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
  role                  :dashboard, :last

  # role                  :infochimps_base
  # role                  :infochimps_final, :last

  facet :elasticsearch do
    instances           1
    recipe              'tuning'
    # recipe            'volumes::build_raid'
    recipe              'elasticsearch::default'
    recipe              'elasticsearch::install_from_release'
    recipe              'elasticsearch::install_plugins'
    recipe              'elasticsearch::server'
  end

end
