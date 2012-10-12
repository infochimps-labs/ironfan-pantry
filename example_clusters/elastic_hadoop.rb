#
# Science cluster -- persistent HDFS
#
# !!Important setup steps!!:
#
# 1. Launch the cluster with the hadoop daemon run states set to 'stop' -- see the
#    section most of the way down the page.
#
# 2. ssh to the machine and run `sudo bash /etc/hadoop/conf/bootstrap_hadoop_namenode.sh`
#
# 3. After initial bootstrap,
#    - set the run_state to :start in the lines below
#    - run `knife cluster sync` to push those values up to chef
#    - run `knife cluster kick` to re-converge
#
# As soon as you see 'nodes=1' on jobtracker (host:50030) & namenode (host:50070)
# control panels, you're good to launch the rest of the cluster.
#
Ironfan.cluster 'elastic_hadoop' do
  cloud(:ec2) do
    permanent           false
    availability_zones ['us-east-1d']
    flavor              'm1.large'
    backing             'ebs'
    image_name          'ironfan-natty'
    bootstrap_distro    'ubuntu10.04-ironfan'
    chef_client_script  'client.rb'
    mount_ephemerals(:tags => { :hadoop_scratch => true, :hadoop_data => false, :persistent => false, :bulk => true })
  end

  environment           :dev

  role                  :systemwide
  cloud(:ec2).security_group :systemwide
  role                  :chef_client
  role                  :ssh
  cloud(:ec2).security_group(:ssh).authorize_port_range 22..22
  role                  :nfs_client
  cloud(:ec2).security_group :nfs_client
  role                  :set_hostname

  role                  :volumes
  role                  :package_set,   :last
  role                  :minidash,      :last

  role                  :org_base
  role                  :org_users
  role                  :org_final,     :last

  role                  :hadoop
  role                  :hadoop_s3_keys
  recipe                'hadoop_cluster::config_files', :last
  role                  :zookeeper_client, :last
  role                  :hbase_client,  :last

  role                  :jruby
  role                  :pig

  role                  :tuning,        :last

  facet :master do
    instances           1
    role                :hadoop_namenode
    role                :hadoop_secondarynn
    role                :hadoop_jobtracker
    role                :hadoop_datanode
    role                :hadoop_tasktracker
  end

  facet :worker do
    instances           2
    role                :hadoop_datanode
    role                :hadoop_tasktracker
  end

  cluster_role.override_attributes({
      :hadoop => {
        # more jobtracker heap size for running large-mapper-count jobs
        :jobtracker  => { :java_heap_size_max => 2000, },
        # lets you rapidly decommission nodes for elasticity
        :balancer    => { :max_bandwidth => (50 * 1024 * 1024) },
        # make mid-flight data much smaller -- useful esp. with ec2 network constraints
        :compress_mapout_codec => 'org.apache.hadoop.io.compress.SnappyCodec',
      },
    })

  #
  # Hadoop Daemon run states
  #
  facet(:master).facet_role.override_attributes({
      :hadoop => {
        :namenode     => { :run_state => :start,  },
        :secondarynn  => { :run_state => :start,  },
        :jobtracker   => { :run_state => :start,  },
        :datanode     => { :run_state => :start,  },
        :tasktracker  => { :run_state => :start,  },
      },
    })

  volume(:ebs1) do
    size                100
    keep                true
    device              '/dev/sdj' # note: will appear as /dev/xvdj on modern ubuntus
    mount_point         '/data/ebs1'
    attachable          :ebs
    snapshot_name       :blank_xfs
    resizable           true
    create_at_launch    true
    tags( :hadoop_data => true, :persistent => true, :local => false, :bulk => true, :fallback => false )
  end

end
