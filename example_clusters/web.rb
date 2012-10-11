Ironfan.cluster 'web' do
  cloud :ec2 do
    # permanent         true
    availability_zones ['us-east-1d']
    flavor              't1.micro'  # change to something larger for serious use
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

  redis_server = "#{cluster_name}-redis_server"
  redis_client = "#{cluster_name}-redis_client"
  facet :webnode do
    instances           6
    role                :nginx
    role                :redis_client
    cloud(:ec2).security_group(redis_server).authorized_by_group(redis_client)
    role                :mysql_client
    role                :elasticsearch_client
    role                :awesome_website
    role                :web_server      # this triggers opening appropriate ports
    cloud(:ec2).security_group(full_name) do
      authorize_port_range  80..80
      authorize_port_range 443..443
    end

    # Rotate nodes among availability zones
    azs = ['us-east-1d', 'us-east-1b', 'us-east-1c']
    (0...instances).each do |idx|
      server(idx).cloud(:ec2).availability_zones [azs[ idx % azs.length ]]
    end
    Chef::Log.warn "Can't pull this trick in v4.x (how do we manipulate individual nodes from Ironfan core?)"
    # # Rote nodes among A/B testing groups
    # (0..instances).each do |idx|
    #  server(idx).chef_node.normal[:split_testing] = ( (idx % 2 == 0) ? 'A' : 'B' ) if server(idx).chef_node
    # end
  end

  facet :dbnode do
    instances           2
    # burly master, wussy workers
    cloud(:ec2).flavor        'm1.large'
    server(0).cloud(:ec2).flavor 'c1.xlarge'
    #
    role                :mysql_server
    volume(:data) do
      size              50
      keep              true
      device            '/dev/sdi' # note: will appear as /dev/xvdi on modern ubuntus
      mount_point       '/data/db'
      attachable        :ebs
      snapshot_name     :blank_xfs
      resizable         true
      create_at_launch  true
      tags( :persistent => true, :local => false, :bulk => false, :fallback => false )
    end
  end

  facet :esnode do
    instances           1
    cloud(:ec2).flavor        "m1.large"
    #
    role                :nginx
    role                :redis_server
    cloud(:ec2).security_group(redis_client)
    role                :elasticsearch_datanode
    role                :elasticsearch_httpnode
  end
end
