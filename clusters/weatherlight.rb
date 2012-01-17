ClusterChef.cluster 'weatherlight' do
  cloud :ec2 do
    defaults
    availability_zones ['us-east-1d']
    flavor              'm1.large'
    backing             'ebs'
    image_name          'cluster_chef-natty'
    bootstrap_distro    'ubuntu10.04-cluster_chef'
    chef_client_script  'client.rb'
    mount_ephemerals(:tags => { :hadoop_scratch => true })
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

  role                  :hadoop
  role                  :hadoop_s3_keys
  recipe                'hadoop_cluster::cluster_conf', :last
  role                  :tuning, :last
  
  facet :master do
    instances           1

    role                :zookeeper_server
    role                :flume_master
    role                :jruby
    role                :hadoop_namenode
    role                :hadoop_datanode
    role                :hadoop_jobtracker
    role                :hadoop_secondarynn
    role                :hadoop_tasktracker

  end

  cluster_role.override_attributes({
    })

  facet(:master).facet_role.override_attributes({
      :dashpot        => {
        :dashboard    => { :run_state => :stop  }, },
      :flume          => {
        :master       => { :run_state => :start  }, },
      :hadoop         => {
        :namenode     => { :run_state => :stop  },
        :secondarynn  => { :run_state => :stop  },
        :jobtracker   => { :run_state => :stop  },
        :datanode     => { :run_state => :stop  },
        :tasktracker  => { :run_state => :stop  }, },
      :zookeeper      => {
        :server       => { :run_state => :stop  }, },
  })

end
