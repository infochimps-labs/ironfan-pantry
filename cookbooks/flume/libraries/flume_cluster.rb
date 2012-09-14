module FlumeCluster

  # Returns the name of the cluster that this flume is playing with
  def flume_cluster
    node[:flume][:cluster_name]
  end

  # returns an array containing the list of flume-masters in this cluster
  def flume_masters
    discover_all(:flume, :master).map(&:private_ip).sort
  end

  # return an exec source curling a newly created signed url to an S3 file
  def s3_source path
    begin
    conn = RightAws::S3Interface.new(node[:aws][:aws_access_key], node[:aws][:aws_secret_access_key], :logger => ::Chef::Log)
    url  = conn.get_link(*parse_s3path(path))
    'exec("curl -q #{url}")'
    rescue RightAws::AwsError => e
      ::Chef::Log.warn("Error during S3 interfacing")
      ::Chef::Log.warn e.message
      'null'
    end
  end

  # given: s3://bucket-name/path/to/file => returns: [ "bucket-name", "path/to/file" ]
  def parse_s3path path
    bucket = path.match(/^s3:\/\/([^\/]*)\//)[1]      rescue ""
    key    = path.match(/^s3:\/\/#{bucket}\/(.*)/)[1] rescue ""
    [ bucket, key ]
  end

  def flume_master
    discover(:flume, :master).private_ip
  end

  # returns the index of the current host in the list of flume masters
  def flume_master_id
    flume_masters.find_index( Ironfan::NodeUtils.private_ip_of( node ) )
  end

  # returns true if this flume is managed by an external zookeeper
  def flume_external_zookeeper
    node[:flume][:master][:external_zookeeper]
  end

  # returns the list of ips of zookeepers in this cluster
  def flume_zookeepers
    discover_all(:zookeeper, :server).map(&:private_ip).sort
  end

  # returns the port to talk to zookeeper on
  def flume_zookeeper_port
    node[:flume][:master][:zookeeper_port]
end

  # returns the list of zookeeper servers with ports
  def flume_zookeeper_list
    flume_zookeepers.map{ |zk| "#{zk}:#{flume_zookeeper_port}"}
  end


  def flume_collect_property( property )
    initial = node[:flume][property]
    initial = [] unless initial
    node[:flume][:plugins].inject( initial ) do | collection, (name,plugin) |
      collection += plugin[property] if plugin[property]
      collection
    end
  end

  # returns the list of plugin classes to include
  def flume_plugin_classes
    flume_collect_property( :classes )
  end

  # returns the list of dirs and jars to include on the FLUME_CLASSPATH
  def flume_classpath
    flume_collect_property( :classpath )
  end

  def flume_java_opts
    flume_collect_property( :java_opts )
  end

end
