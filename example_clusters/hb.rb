#
# HBase with persisten EBS-backed storage.
#
# For serious use, you will want to go to larger nodes (`m1.xlarge` works well
# for us) and should NOT use EBS-backed storage. We assume that for initial
# experimentation you'll want to start/stop this, so it comes out of the box
# with EBS.
#
# !!Important setup steps!!:
#
# Launch the cluster with the hadoop daemon run states set to 'stop' -- see the
# section most of the way down the page.
#
# After initial bootstrap,
# * set the run_state to :start for all but the jobtracker and tasktracker (for an hbase client, these will typically be left at `:stop`)
# * run `knife cluster sync` to push those values up to chef
# * run `knife cluster kick` to re-converge
#
# As soon as you see 'nodes=1' on jobtracker (host:50030) & namenode (host:50070)
# control panels, you're good to launch the rest of the cluster.
#
Ironfan.cluster 'hb' do
  cloud(:ec2) do
    # permanent         true
    availability_zones ['us-east-1d']
    flavor              'm1.large'
    backing             'ebs'
    image_name          'ironfan-natty'
    bootstrap_distro    'ubuntu10.04-ironfan'
    chef_client_script  'client.rb'
    mount_ephemerals(:tags => { :hbase_scratch => true, :hadoop_scratch => true })
  end

  flume_cluster_name     = :dds
  hbase_cluster_name     = :hb
  science_cluster_name   = :elastic_hadoop
  zookeeper_cluster_name = :zk

  environment           :dev

  cluster_overrides = Mash.new({
      # Look for the zookeeper nodes in the dedicated zookeeper cluster
      :discovers => {
        :zookeeper    => { :server    => zookeeper_cluster_name },
      },
      :hadoop         => {
        :namenode     => { :run_state => :start,  },
        :secondarynn  => { :run_state => :start,  },
        :datanode     => { :run_state => :start,  },
        :jobtracker   => { :run_state => :stop,  }, # leave this at 'stop', usually
        :tasktracker  => { :run_state => :stop,  }, # leave this at 'stop', usually
        :compress_mapout_codec => 'org.apache.hadoop.io.compress.SnappyCodec',
      },
      :hbase          => {
        :master       => { :run_state => :start  },
        :regionserver => { :run_state => :start  },
        :stargate     => { :run_state => :start  }, },
      :zookeeper      => {
        :server       => { :run_state => :start  }, },
    })

  #
  ## Uncomment the lines below to stop all services on the cluster
  #
  #  cluster_overrides[:hadoop   ][:namenode     ][:run_state] = :stop
  #  cluster_overrides[:hadoop   ][:secondarynn  ][:run_state] = :stop
  #  cluster_overrides[:hadoop   ][:datanode     ][:run_state] = :stop
  #  cluster_overrides[:hbase    ][:master       ][:run_state] = :stop
  #  cluster_overrides[:hbase    ][:regionserver ][:run_state] = :stop
  #  cluster_overrides[:hbase    ][:stargate     ][:run_state] = :stop
  #  cluster_overrides[:zookeeper][:server       ][:run_state] = :stop

  # # total size of the JVM heap (regionserver) (default 2000m)
  # cluster_overrides[:hbase][:regionserver][:java_heap_size_max] = "4000m"
  #
  # # hbase.hregion.memstore.mslab.enabled (default false) -- Experimental: Enables the
  # #   MemStore-Local Allocation Buffer, a feature which works to prevent heap fragmentation
  # #   under heavy write loads. This can reduce the frequency of stop-the-world GC pauses on
  # #   large heaps.
  # cluster_overrides[:hbase][:memstore] ||= {}
  # cluster_overrides[:hbase][:memstore][:mslab_enabled]          = true
  #
  # # Setting this to 0 entirely removes the limit on concurrent connections. This is necessary
  # #   to overcome https://issues.apache.org/jira/browse/HBASE-4684 in HBase 0.90.4
  # cluster_overrides[:zookeeper][:max_client_connections]        = 0

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
  recipe                'hbase::config_files',          :last

  role                  :jruby
  role                  :pig

  role                  :tuning,        :last

  facet :alpha do
    instances           1
    role                :hadoop_namenode
    role                :hbase_master
  end
  facet :beta do
    instances           1
    role                :hadoop_secondarynn
    role                :hadoop_jobtracker
    role                :hbase_master
  end
  facet :worker do
    instances           3
    role                :hadoop_datanode
    role                :hadoop_tasktracker
    role                :hbase_regionserver
    role                :hbase_stargate
    role                :hbase_thrift
  end

  # This line, and the 'discovers' setting in the cluster_role,
  # enable the hbase to use an external zookeeper cluster
  cloud(:ec2).security_group(self.name) do
    authorized_by_group(zookeeper_cluster_name)
    authorize_group(flume_cluster_name)
    authorize_group(science_cluster_name)
  end

  #
  # Attach persistent storage to each node, and use it for all hadoop data_dirs.
  #
  volume(:ebs1) do
    size                10
    keep                true
    device              '/dev/sdj' # note: will appear as /dev/xvdj on modern ubuntus
    mount_point         '/data/ebs1'
    attachable          :ebs
    snapshot_name       :blank_xfs
    resizable           true
    create_at_launch    true
    tags( :hbase_data => true, :hadoop_data => true, :zookeeper_data => true, :persistent => true, :local => false, :bulk => true, :fallback => false )
  end

  cluster_role.override_attributes(cluster_overrides)
end
