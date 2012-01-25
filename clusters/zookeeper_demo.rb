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
    flavor              'm1.large'
    backing             'ebs'
    image_name          'cluster_chef-natty'
    bootstrap_distro    'ubuntu10.04-cluster_chef'
    mount_ephemerals(:tags => { :zookeeper_journal => true, :zookeeper_scratch => true, :zookeeper_data => false, })
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
  role                  :jruby

  facet :zookeeper do
    instances           3
    role                :zookeeper_server
  end

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
    device              '/dev/sdk' # note: will appear as /dev/xvdk on natty
    mount_point         '/data/ebs1'
    attachable          :ebs
    snapshot_name       :blank_xfs
    resizable           true
    tags( :zookeeper_data => true, :zookeeper_journal => false, :persistent => true, :local => false, :bulk => true, :fallback => false )
    create_at_launch    true
  end

end
