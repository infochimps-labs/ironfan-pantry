ClusterChef.cluster 'hadoop_demo' do
  cloud :ec2 do
    defaults
    availability_zones ['us-east-1d']
    flavor              'm1.large'
    backing             'ebs'
    image_name          'infochimps-natty'
    bootstrap_distro    'ubuntu10.04-cluster_chef'
    chef_client_script  'client.rb'
    mount_ephemerals(:tags => { :hadoop_scratch => true })
  end

  environment           :prod

  role                  :base_role
  role                  :chef_client
  role                  :ssh
  role                  :nfs_client

  role                  :volumes
  role                  :package_set, :last
  role                  :dashboard,   :last

  role                  :hadoop
  role                  :hadoop_s3_keys
  role                  :pig
  recipe                'hadoop_cluster::cluster_conf', :last

  facet :master do
    instances           1
    role                :hadoop_namenode
    role                :hadoop_jobtracker
    role                :hadoop_secondarynn
    role                :hadoop_tasktracker
    role                :hadoop_datanode
  end

  facet :worker do
    instances           6
    role                :hadoop_tasktracker
    role                :hadoop_datanode
  end

  volume(:ebs1) do
    defaults
    size                200
    device              '/dev/sdj' # note: will appear as /dev/xvdi on natty
    mount_point         '/data/ebs1'
    attachable          :ebs
    snapshot_id         'snap-9d1dc4ff' # 200gb xfs
    tags( :hadoop_datadirs => true, :persistent => true, :local => false, :bulk => true, :fallback => false )
    create_at_launch    true # if no volume is tagged for that node, it will be created
  end

  cluster_role.override_attributes({
      :apt    => { :cloudera => { :force_distro => 'maverick',  }, },
      :hadoop => {
        :java_heap_size_max  => 1400,
        :namenode            => { :java_heap_size_max => 1000, },
        :secondarynn         => { :java_heap_size_max => 1000, },
        :jobtracker          => { :java_heap_size_max => 3072, },
        :datanode            => { :java_heap_size_max => 1400, },
        :tasktracker         => { :java_heap_size_max => 1400, },
        :balancer            => { :max_bandwidth => (50 * 1024 * 1024) },
        :compress_mapout_codec => 'org.apache.hadoop.io.compress.SnappyCodec',
      }
    })

  #
  # After initial bootstrap, comment out the first set of lines (which stop all
  # the services that want a namenod to connect to) and uncomment the ones that
  # follow. Then run `knife cluster sync bonobo-master` followed by `knife
  # cluster kick bonobo-master` to re-converge.
  #
  # As soon as you see 'nodes=1' on the jobtracker (host:50030) and
  # namenode (host:50070) control panels, you're good to launch the rest
  # of the cluster (`knife cluster launch bonobo`)
  #
  facet(:master).facet_role.override_attributes({
      :hadoop => {
        :namenode    => { :run_state => :start, },
        :secondarynn => { :run_state => :stop,  },
        :jobtracker  => { :run_state => :stop,  },
        :datanode    => { :run_state => :stop,  },
        :tasktracker => { :run_state => :stop,  },
      },
    })

end
