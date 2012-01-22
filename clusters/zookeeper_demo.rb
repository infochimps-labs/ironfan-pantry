#
# A zookeeper quorum
#
# The only sensible numbers of instances to launch with are 3 or 5.  A solo
# zookeeper doesn't guarantee availability; and you should NEVER run an even
# number of ZKs (http://hbase.apache.org/book/zookeeper.html).
#
ClusterChef.cluster 'zookeeper_demo' do
  cloud(:ec2) do
    defaults
    availability_zones ['us-east-1d']
    flavor              't1.micro'
    backing             'ebs'
    image_name          'cluster_chef-natty'
    bootstrap_distro    'ubuntu10.04-cluster_chef'
    mount_ephemerals(:tags => { :zookeeper_scratch => true, :zookeeper_data    => false, })
  end

  # uncomment if you want to set your environment.
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

  role                  :tuning

  facet :zookeeper do
    instances           1
    role                :zookeeper_server
  end

  cluster_role.override_attributes({
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
  facet(:zookeeper).facet_role.override_attributes({
      :zookeeper => {
        :server      => { :run_state => :start, },
      },
    })

  #
  # Attach 10GB persistent storage to each node, and use it for all zookeeper data_dirs.
  #
  # Modify the snapshot ID and attached volume size to suit
  #
  volume(:ebs1) do
    defaults
    size                10
    keep                true
    device              '/dev/sdk' # note: will appear as /dev/xvdi on natty
    mount_point         '/data/ebs1'
    attachable          :ebs
    snapshot_id         nil
    tags( :zookeeper_data => true, :persistent => true, :local => false, :bulk => true, :fallback => false )
    create_at_launch    true # if no volume is tagged for that node, it will be created
  end

end
