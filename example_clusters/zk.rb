#
# A zookeeper quorum
#
# The only sensible numbers of instances to launch with are 3 or 5.  A solo
# zookeeper doesn't guarantee availability; and you should NEVER run an even
# number of ZKs (http://hbase.apache.org/book/zookeeper.html).
#
Ironfan.cluster 'zk' do
  cloud(:ec2) do
    permanent           true
    availability_zones ['us-east-1d']
    flavor              't1.micro'  # change to something larger for serious use
    backing             'ebs'
    image_name          'ironfan-natty'
    bootstrap_distro    'ubuntu10.04-ironfan'
    chef_client_script  'client.rb'
    mount_ephemerals(:tags => { :zookeeper_journal => true, :zookeeper_scratch => true, :zookeeper_data => false, })
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

  role                  :jruby

  role                  :tuning,        :last

  facet :zookeeper do
    instances           1
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
    size                10
    keep                true
    device              '/dev/sdk' # note: will appear as /dev/xvdk on natty
    mount_point         '/data/ebs1'
    attachable          :ebs
    snapshot_name       :blank_xfs
    resizable           true
    create_at_launch    true
    tags( :zookeeper_data => true, :zookeeper_journal => false, :persistent => true, :local => false, :bulk => true, :fallback => false )
  end

end
