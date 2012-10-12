#
# Metropolis demo cluster -- runs graphite, statsd, goliath-statsd
#
Ironfan.cluster 'metropolis' do
  cloud(:ec2) do
    permanent           false
    availability_zones ['us-east-1d']
    flavor              't1.micro'
    backing             'ebs'
    image_name          'ironfan-natty'
    bootstrap_distro    'ubuntu10.04-ironfan'
    chef_client_script  'client.rb'
    mount_ephemerals
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

  role                  :tuning,        :last

  facet :master do
    instances           1

    role                :graphite_server
    role                :statsd_server
  end

  cluster_role.override_attributes({
    })

  volume(:ebs1) do
    size                10
    keep                true
    device              '/dev/sdj' # note: will appear as /dev/xvdj on modern ubuntus
    mount_point         '/data/ebs1'
    attachable          :ebs
    snapshot_name       :blank_xfs
    resizable           true
    create_at_launch    true
    tags( :graphite_data => true, :persistent => true, :bulk => true, :local => false, :fallback => false )
  end
end
