#
# Pygmy Elephant cluster!
#
# Nothing special -- one master that does everything; debug your job, then
# launch the workers to run it for real.
#
#
# You will need the role definitions from
# [cluster_chef-homebase](https://github.com/infochimps-labs/cluster_chef-homebase)
# to use this cluster
#
ClusterChef.cluster 'pygmy' do
  cloud(:ec2) do
    defaults
    availability_zones ['us-east-1d']
    # if you're curious, these recipes *will* work on a t1.micro. just don't use
    # it for anything.
    flavor              'm1.large'
    backing             'ebs'
    image_name          'natty'
    bootstrap_distro    'ubuntu10.04-cluster_chef'
    chef_client_script  'client.rb'
    mount_ephemerals(:tags => { :hadoop_scratch => true })
  end

  role                  :volumes
  role                  :hadoop
  role                  :hadoop_s3_keys
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
    role                :hadoop_tasktracker
  end

  facet :worker do
    instances           2
    role                :hadoop_datanode
    role                :hadoop_tasktracker
  end

  cluster_role.override_attributes({
      # No cloudera package for natty or oneiric yet: use the maverick one
      :apt    => { :cloudera => { :force_distro => 'maverick',  }, },
      :hadoop                => {
        :java_heap_size_max  => 1000,
        :namenode            => { :java_heap_size_max => 1000, },
        :secondarynn         => { :java_heap_size_max => 1000, },
        :jobtracker          => { :java_heap_size_max => 1200, },
        :datanode            => { :java_heap_size_max => 1000, },
        :tasktracker         => { :java_heap_size_max => 1000, },
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
end
