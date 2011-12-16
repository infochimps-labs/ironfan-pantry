#
# Science cluster!
#
# This is the hadoop cluster definition we use at infochimps for our science
# cluster. Storing the HDFS on persistent (EBS) volumes means we can stop the
# cluster at the end of the day (leaving the master node running) -- it only
# takes about ten minutes to bring the cluster back online.
#
# Using tasktrackers that are not datanodes means you can blow out the size of
# your cluster and not have to wait later for nodes to decommission. Obviously
# their jobs will run slower-than-optimal, but we'd rather have sub-optimal
# robots than sub-optimal data scientists.
#
# You will need the role definitions from
# [cluster_chef-homebase](https://github.com/infochimps-labs/cluster_chef-homebase)
# to use this cluster.
#
# To use this, please update the snapshot_id (and volume size) in the volume
# stanza at the end.
#
ClusterChef.cluster 'science' do
  cloud(:ec2) do
    defaults
    availability_zones ['us-east-1d']
    flavor              'm1.xlarge'
    backing             'ebs'
    image_name          'natty'
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
  role                  :dashboard

  role                  :hadoop
  role                  :hadoop_s3_keys
  role                  :tuning
  role                  :jruby
  role                  :pig
  recipe                'hadoop_cluster::cluster_conf', :last

  # We don't hold much data on our HDFS -- most of it goes in S3 -- so we can
  # afford to have the namenode and jobtracker on the same machine.  If your
  # cluster is much larger than what's shown here, use a separate jobtracker.
  facet :master do
    instances           1
    role                :hadoop_namenode
    role                :hadoop_secondarynn
    role                :hadoop_jobtracker
    role                :hadoop_datanode
  end

  facet :worker do
    instances           6
    role                :hadoop_datanode
    role                :hadoop_tasktracker
  end

  # Use for cheap elasticity only: spin these up for CPU-intensive job stages
  # and blow them away at will.
  facet :taskonly do
    instances           10
    role                :hadoop_tasktracker
  end

  cluster_role.override_attributes({
      # No cloudera package for natty or oneiric yet: use the maverick one
      :apt    => { :cloudera => { :force_distro => 'maverick',  }, },
      :hadoop                => {
        :java_heap_size_max  => 1400,
        :namenode            => { :java_heap_size_max => 1400, },
        :secondarynn         => { :java_heap_size_max => 1400, },
        :jobtracker          => { :java_heap_size_max => 3072, },
        :datanode            => { :java_heap_size_max => 1400, },
        :tasktracker         => { :java_heap_size_max => 1400, },
        :balancer => { :max_bandwidth => (50 * 1024 * 1024) },
        :compress_mapout_codec => 'org.apache.hadoop.io.compress.SnappyCodec',
      }
    })

  # Launch the cluster with all of the below set to 'stop'.
  #
  # After initial bootstrap,
  # * set the run_state to 'start' in the lines below
  # * run `knife cluster sync bonobo-master` to push those values up to chef
  # * run `knife cluster kick bonobo-master` to re-converge
  #
  # Once you see 'nodes=1' on jobtracker (host:50030) & namenode (host:50070)
  # control panels, you're good to launch the rest of the cluster.
  #
  facet(:master).facet_role.override_attributes({
      :hadoop => {
        :namenode    => { :run_state => :stop, },
        :secondarynn => { :run_state => :stop, },
        :jobtracker  => { :run_state => :stop, },
        :datanode    => { :run_state => :stop, },
        :tasktracker => { :run_state => :stop,  },
      },
    })

  #
  # Attach 600GB persistent storage to each node, and use it for all hadoop data_dirs.
  #
  # Modify the snapshot ID and attached volume size to suit
  #
  facet(:worker).volume(:ebs1) do
    defaults
    size                200
    keep                true
    device              '/dev/sdj' # note: will appear as /dev/xvdi on natty
    mount_point         '/data/ebs1'
    attachable          :ebs
    snapshot_id         HADOOP_DATA_VOL_SNAPSHOT_ID # 200gb xfs
    tags( :hadoop_data => true, :persistent => true, :local => false, :bulk => true, :fallback => false )
    create_at_launch    true # if no volume is tagged for that node, it will be created
  end
  # "I'll have what she's having"
  facet(:master).volume(:ebs1, (facet(:worker).volume(:ebs1)))
end
