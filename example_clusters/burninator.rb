#
# Burninator cluster -- populate an AMI with installed software, but no
# services, users or other preconceptions.
#
# The script /tmp/burn_ami_prep.sh will help finalize the machine -- then, just
# stop it and invoke 'Create Image (EBS AMI)'.
#
Ironfan.cluster 'burninator' do

  cloud(:ec2) do
    permanent           false
    availability_zones ['us-east-1d']
    # use a c1.xlarge so the AMI knows about all ephemeral drives
    flavor              'c1.xlarge'
    backing             'ebs'
    # image_name is per-facet here
    bootstrap_distro    'ubuntu10.04-ironfan'
    chef_client_script  'client.rb'
    mount_ephemerals
  end

  environment           :_default

  role                  :chef_client
  role                  :ssh              ; cloud(:ec2).security_group(:ssh).authorize_port_range 22..22

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

    cloud(:ec2) do
      image_name          'precise' # Leave set at vanilla precise
      bootstrap_distro    'ubuntu12.04-ironfan'
    end

    recipe              'cloud_utils::burn_ami_prep'
    recipe              'users::ubuntu'

    role                :package_set, :last

    recipe              'ant'
    recipe              'boost'
    recipe              'build-essential'
    recipe              'emacs'
    recipe              'git'
    recipe              'java'
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
    recipe              'zsh'

    facet_role.override_attributes({
        :java        => { # use oracle java
          :install_flavor => 'oracle',
          :jdk => { 6 => { :x86_64 => {
            :url        => 'http://artifacts.chimpy.us.s3.amazonaws.com/tarballs/jdk-6u32-linux-x64.bin',
            :checksum   => '269d05b8d88e583e4e66141514d8294e636f537f55eb50962233c9e33d8f8f49'
           } } }
        },
        :package_set    => { :install   => %w[ base dev sysadmin text python emacs ] },
        :apt            => { :cloudera  => { :force_distro => 'maverick',  }, },
      })
  end

  #
  # Used to test the generated AMI.
  #
  facet :village do
    instances     1
    # Once the AMI is burned, add a new entry in your knife configuration -- see
    # knife/example-credentials/knife-org.rb. Fill in its name here:
    cloud(:ec2).image_name    'ironfan-precise'

    # just so there's something in the runlist.
    recipe              'motd'
  end

end
