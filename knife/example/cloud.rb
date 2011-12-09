Chef::Config.instance_eval do

  # # Uncomment these lines to set your chef server explicitly
  # chef_server_url "http://33.33.33.20:4000/"
  # cluster_path  [ "#{homebase_dir}/clusters", "#{homebase_dir}/vendor/infochimps_v2/clusters" ]

  # ===========================================================================
  #
  # VM Settings
  #


  # ===========================================================================
  #
  # Cloud Settings
  #

  #
  # Add your own AMIs to the hash below
  #
  Chef::Config[:ec2_image_info] ||= {}
  ec2_image_info.merge!({
      %w[us-east-1  64-bit  ebs  YOURNAME-natty ] => { :image_id => 'ami-0df63864', :ssh_user => 'ubuntu', :bootstrap_distro => "ubuntu10.04-cluster_chef", },
    })
  Chef::Log.debug("Loaded #{__FILE__}, now have #{ec2_image_info.size} ec2 images")

end
