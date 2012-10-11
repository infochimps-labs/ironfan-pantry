#
# Sandbox cluster -- use this for general development
#
Ironfan.cluster 'sandbox' do
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

  facet :simple do
    instances           1
  end

  facet :raid_demo do
    instances           1
    cloud(:ec2).flavor        'm1.large'
    recipe              'volumes::build_raid', :first

    cloud(:ec2).mount_ephemerals
    raid_group(:md0) do
      device            '/dev/md0'
      mount_point       '/raid0'
      level             0
      sub_volumes       [:ephemeral0, :ephemeral1]
    end
  end

  cluster_role.override_attributes({
    })
end
