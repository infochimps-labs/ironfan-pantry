#
# Bigass cluster!
#
# This is the hadoop cluster definition we use at infochimps for our production
# hadoop runs. The HDFS is ONLY a scratch pad; anything we want to keep goes
# into S3.
#
# This enables stupid, dangerous, awesome things like:
# * spin up a few dozen c1.xlarge CPU-intensive machines, parse a ton of data,
#   store it back into S3.
# * blow all the workers away and reformat the namenode (`/etc/hadoop/conf/nuke_hdfs_from_orbit_its_the_only_way_to_be_sure.sh.erb`)
# * spin up a cluster of m2.2xlarge memory-intensive machines to group and
#   filter it; store the final results into S3.
# * shut the entire cluster down.
#
#
# You will need the role definitions from
# [cluster_chef-homebase](https://github.com/infochimps-labs/cluster_chef-homebase)
# to use this cluster
#
ClusterChef.cluster 'bigass' do
  cloud(:ec2) do
    defaults
    availability_zones ['us-east-1d']
    flavor              'm1.xlarge'
    backing             'ebs'
    image_name          'natty'
    bootstrap_distro    'ubuntu10.04-cluster_chef'
    chef_client_script  'client.rb'
    mount_ephemerals(:tags => { :hadoop_data => true, hadoop_scratch => true })
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

  facet :namenode do
    instances           1
    role                :hadoop_namenode
    role                :hadoop_secondarynn
    # the datanode is only here for convenience while bootstrapping.
    # if your cluster is large, set its run_state to 'stop' (or remove it)
    role                :hadoop_datanode
  end

  facet :jobtracker do
    instances           1
    role                :hadoop_jobtracker
  end

  facet :worker do
    instances           30
    role                :hadoop_datanode
    role                :hadoop_tasktracker
  end

  cluster_role.override_attributes({
      # No cloudera package for natty or oneiric yet: use the maverick one
      :apt    => { :cloudera => { :force_distro => 'maverick',  }, },
      :hadoop                => {
        :java_heap_size_max  => 1400,
        # NN
        :namenode            => { :java_heap_size_max => 1400, },
        :secondarynn         => { :java_heap_size_max => 1400, },
        # M
        :jobtracker          => { :java_heap_size_max => 3072, },
        :datanode            => { :java_heap_size_max => 1400, },
        :tasktracker         => { :java_heap_size_max => 1400, },
        # if you're going to play games with your HDFS, crank up the rebalance speed
        :balancer => { :max_bandwidth => (50 * 1024 * 1024) },
        # compress mid-flight (but not final output) data
        :compress_mapout_codec => 'org.apache.hadoop.io.compress.SnappyCodec',
        # larger s3 blocks = fewer tiny map tasks
        :s3_block_size       => (128 * 1024 * 1024),
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
        :namenode    => { :run_state => :start, },
        :secondarynn => { :run_state => :start, },
        :jobtracker  => { :run_state => :start, },
        :datanode    => { :run_state => :start, },
        :tasktracker => { :run_state => :stop,  },
      },
    })

end
