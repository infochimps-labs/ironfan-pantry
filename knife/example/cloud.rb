
#
# Add your own AMIs to the hash below
#
#
Chef::Config[:ec2_image_info] ||= {}
Chef::Config[:ec2_image_info].merge!({

    %w[us-east-1  64-bit  ebs  YOURNAME-natty ] => { :image_id => 'ami-0df63864', :ssh_user => 'ubuntu', :bootstrap_distro => "ubuntu10.04-cluster_chef", },

  })

Chef::Log.debug("Loaded #{__FILE__}, now have #{Chef::Config[:ec2_image_info].size} ec2 images")
