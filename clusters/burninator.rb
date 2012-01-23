#
# Burninator cluster -- populate an AMI with installed software, but no
# services, users or other preconceptions.
#
# The script /tmp/burn_ami_prep.sh will help finalize the machine -- then, just
# stop it and invoke 'Create Image (EBS AMI)'.
#
ClusterChef.cluster 'burninator' do
  cloud(:ec2) do
    defaults
    availability_zones ['us-east-1d']
    # use a c1.xlarge so the AMI knows about all ephemeral drives
    flavor              'c1.xlarge'
    backing             'ebs'
    # image_name is per-facet here
    bootstrap_distro    'ubuntu10.04-cluster_chef'
    chef_client_script  'client.rb'
    mount_ephemerals
  end

  environment           :dev

  role                  :base_role
  role                  :chef_client
  role                  :ssh

  # It's handy to have the root volumes not go away with the machine.
  # It also means you can find yourself with a whole ton of stray 8GB
  # images once you're done burninatin' so make sure to go back and
  # clear them out
  volume(:root).keep    true

  #
  # A throwaway facet for AMI generation
  #
  facet :trogdor do
    instances           1

    cloud.image_name    'natty'  # Leave set at vanilla natty

    recipe              'cloud_utils::burn_ami_prep'

    role                :package_set, :last

    recipe              'ant'
    recipe              'boost'
    recipe              'build-essential'
    recipe              'git'
    recipe              'java::sun'
    recipe              'jpackage'
    recipe              'jruby'
    recipe              'jruby::gems'
    recipe              'nodejs'
    recipe              'ntp'
    recipe              'openssl'
    recipe              'pig::install_from_release'
    recipe              'hadoop_cluster::add_cloudera_repo'
    recipe              'runit'
    recipe              'thrift'
    recipe              'xfs'
    recipe              'xml'
    recipe              'zlib'

    facet_role.override_attributes({
        :package_set => { :install => %w[ base dev sysadmin text python emacs ] },
        :apt    => { :cloudera => { :force_distro => 'maverick',  }, },
      })
  end

  #
  # Used to test the generated AMI.
  #
  facet :village do
    instances     1
    # Once the AMI is burned, add a new entry in your knife configuration -- see
    # knife/example-credentials/knife-org.rb. Fill in its name here:
    cloud.image_name    'cluster_chef-natty'
  end

end
