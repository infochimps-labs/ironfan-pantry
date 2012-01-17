# -*- coding: utf-8 -*-
#
# El Ridiculoso Grande -- esto es un clúster gordo que tiene todo lo que en él
#
# Maybe you're wondering what would happen if you installed everything in sight
# on the same node. Here's your chance to find out.
#
ClusterChef.cluster 'el_ridiculoso' do
  cloud(:ec2) do
    defaults
    availability_zones ['us-east-1d']
    flavor              'c1.xlarge'
    backing             'ebs'
    image_name          'cluster_chef-natty'
    bootstrap_distro    'ubuntu10.04-cluster_chef'
    chef_client_script  'client.rb'
    mount_ephemerals(:tags => { :hadoop_scratch => true })
  end

  environment           :dev

  role                  :base_role
  role                  :chef_client
  role                  :ssh
  role                  :nfs_client

  role                  :volumes
  role                  :package_set, :last
  role                  :dashboard,   :last

  role                  :org_base
  role                  :org_final, :last
  role                  :org_users

  role                  :hadoop
  role                  :hadoop_s3_keys
  recipe                'hadoop_cluster::cluster_conf', :last
  role                  :tuning, :last

  facet :grande do
    instances           1

    role                :cassandra_server
    role                :elasticsearch_data_esnode
    role                :elasticsearch_http_esnode
    role                :zookeeper_server
    role                :flume_master
    role                :flume_agent
    role                :ganglia_master
    role                :ganglia_agent
    role                :hadoop_namenode
    role                :hadoop_datanode
    role                :hadoop_jobtracker
    role                :hadoop_secondarynn
    role                :hadoop_tasktracker
    role                :hbase_master
    role                :hbase_regionserver
    role                :hbase_stargate
    role                :redis_server

    role                :mysql_client
    role                :redis_client
    role                :cassandra_client
    role                :elasticsearch_client
    role                :nfs_client
    role                :jruby
    role                :pig

    #
    # more shit to install
    #
    recipe              'ant'
    recipe              'bluepill'
    recipe              'boost'
    recipe              'build-essential'
    recipe              'cron'
    recipe              'git'
    recipe              'hive'
    recipe              'java::sun'
    recipe              'jpackage'
    recipe              'jruby'
    recipe              'nodejs'
    recipe              'ntp'
    recipe              'openssh'
    recipe              'openssl'
    recipe              'rstats'
    recipe              'runit'
    recipe              'thrift'
    recipe              'xfs'
    recipe              'xml'
    recipe              'zabbix'
    recipe              'zlib'

    #
    # These run stuff
    #
    recipe              'apache2'
    recipe              'nginx'

    # role                :statsd_server
    # role                :mongodb_server
    # role                :mysql_server
    # role                :graphite_server
    # role                :resque_server

  end

  cluster_role.override_attributes({
      :hadoop => {
        :java_heap_size_max    => 128,
      },
    })

  facet(:grande).facet_role.override_attributes({
      :cassandra      => {
        :server       => { :run_state => :stop  }, },
      :dashpot        => {
        :dashboard    => { :run_state => :stop  }, },
      :elasticsearch  => {
        :server       => { :run_state => :stop  }, },
      :flume          => {
        :master       => { :run_state => :stop  },
        :node         => { :run_state => :stop  }, },
      :ganglia        => {
        :server       => { :run_state => :stop },
        :monitor      => { :run_state => :stop }, },
      :graphite       => {
        :carbon       => { :run_state => :stop  },
        :whisper      => { :run_state => :stop  },
        :dashboard    => { :run_state => :stop  }, },
      :hadoop         => {
        :namenode     => { :run_state => :stop  },
        :secondarynn  => { :run_state => :stop  },
        :jobtracker   => { :run_state => :stop  },
        :datanode     => { :run_state => :stop  },
        :tasktracker  => { :run_state => :stop  }, },
      :hbase          => {
        :master       => { :run_state => :stop  },
        :regionserver => { :run_state => :stop  },
        :stargate     => { :run_state => :stop  }, },
      :mongodb        => {
        :server       => { :run_state => :stop  }, },
      :mysql          => {
        :server       => { :run_state => :stop  }, },
      :redis          => {
        :server       => { :run_state => :stop  }, },
      :resque         => {
        :server       => { :run_state => :stop  }, },
      :statsd         => {
        :server       => { :run_state => :stop  }, },
      :zookeeper      => {
        :server       => { :run_state => :stop  }, },
  })

end
