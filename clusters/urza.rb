ClusterChef.cluster 'urza' do
  cloud :ec2 do
    defaults
    availability_zones ['us-east-1d']
    flavor              't1.micro'
    backing             'ebs'
    bootstrap_distro    'ubuntu10.04-cluster_chef'
    image_name          'infochimps-natty'
    chef_client_script  'client.rb'
    mount_ephemerals
  end

  environment           :dev

  # DO NOT try to be clever and add the users role to this. Just don't do it.

  role                  :base_role
  role                  :chef_client
  role                  :ssh
  role                  :org_base
  role                  :org_final,   :last
  
  role                  :volumes 
  role                  :package_set, :last
  role                  :dashboard,   :last
  role                  :tuning,      :last

  facet :nfs do
    server(0).fullname  "urza-nfs" 
    
    role                :nfs_server
    
    facet_role do
      override_attributes({
          :nfs => { :exports => {
              '/home' => { :name => 'home', :nfs_options => '*.internal(rw,no_root_squash,no_subtree_check)', :realm => 'all' },
            } },
        })
    end

    volume(:home_vol) do
      defaults
      size                20
      keep                true
      device              '/dev/sdh' # note: will appear as /dev/xvdh on natty
      mount_point         '/home'
      attachable          :ebs
      snapshot_id         'snap-94b1d7f0' # 20gb home_vol
      tags( :persistent => true, :local => false, :bulk => false, :fallback => false )
      create_at_launch     true
    end
  end

end
