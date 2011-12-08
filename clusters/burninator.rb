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
    flavor              'c1.xlarge'
    backing             'ebs'
    image_name          'natty'
    bootstrap_distro    'ubuntu10.04-cluster_chef'
    chef_client_script  'client.rb'
    mount_ephemerals(:tags => { :hadoop_scratch => true })
  end

  environment           :dev

  role                  :base_role
  role                  :chef_client
  role                  :ssh
  role                  :nfs_client

  #
  # A throwaway facet for AMI generation
  #
  facet :trogdor do
    instances           1

    recipe              'cloud_utils::burn_ami_prep'

    role                :package_set, :last
    role                :hadoop
    role                :pig

    recipe              'ant'
    recipe              'boost'
    recipe              'build-essential'
    recipe              'git'
    recipe              'java::sun'
    recipe              'jpackage'
    recipe              'jruby'
    recipe              'nodejs'
    recipe              'ntp'
    recipe              'openssl'
    recipe              'runit'
    recipe              'thrift'
    recipe              'xfs'
    recipe              'xml'
    recipe              'zabbix'
    recipe              'zlib'
  end

  facet :village do
    instances        1
    cloud.image_name 'infochimps-natty'
  end

end
