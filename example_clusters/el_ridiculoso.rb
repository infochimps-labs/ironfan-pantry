# -*- coding: utf-8 -*-
#
# El Ridiculoso Grande -- esto es un clúster gordo que tiene todo lo que en él
#
# Maybe you're wondering what would happen if you installed everything in sight
# on the same node. Here's your chance to find out.
#
Ironfan.cluster 'el_ridiculoso' do
  cloud(:ec2) do
    availability_zones ['us-east-1d']
    flavor              'c1.xlarge'
    backing             'ebs'
    image_name          'ironfan-natty'
    bootstrap_distro    'ubuntu10.04-ironfan'
    chef_client_script  'client.rb'
    mount_ephemerals(:tags => { :hadoop_scratch => true })
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

  role                  :hadoop
  role                  :hadoop_s3_keys
  recipe                'hadoop_cluster::config_files', :last
  role                  :hbase_client,     :last
  role                  :zookeeper_client, :last

  # role                :log_integration
  # role                :zabbix_agent,  :last
  recipe                'cloud_utils::pickle_node', :last

  module ElRidiculoso
    module_function
    def redis_server()  "#{cluster_name}-redis_server";    end
    def redis_client()  "#{cluster_name}-redis_client";    end

    def master_processes
      role              :cassandra_server
      role              :elasticsearch_datanode
      role              :elasticsearch_httpnode
      role              :flume_master
      role              :ganglia_master
      role              :graphite_server
      role              :hadoop_jobtracker
      role              :hadoop_namenode
      role              :hadoop_secondarynn
      role              :hbase_master
#      role              :jenkins_server
      role              :mongodb_server
      role              :mysql_server
      role              :redis_server
      cloud(:ec2).security_group(redis_server).authorized_by_group(redis_client)

      role              :resque_server
      role              :statsd_server
      role              :zabbix_server
      #role              :zabbix_web
      role              :zookeeper_server
      # The default recipes for these run stuff even though it's impolite
      recipe              'apache2'
      recipe              'nginx'
    end

    def worker_processes
      role              :flume_agent
      role              :ganglia_agent
      role              :hadoop_datanode
      role              :hadoop_tasktracker
      role              :hbase_regionserver
      role              :hbase_stargate
      role              :hbase_thrift
      role              :jenkins_worker
    end

    def client_processes
      role              :cassandra_client
      role              :elasticsearch_client
      role              :hbase_client
      role              :mysql_client
      role              :nfs_client
      role              :redis_client
      cluster_name =    self.cluster_name
      cloud(:ec2).security_group(redis_client)
      role              :zookeeper_client
    end

    def simple_installs
      role              :jruby
      role              :pig
      recipe            'ant'
      recipe            'bluepill'
      recipe            'boost'
      recipe            'build-essential'
      recipe            'cron'
      recipe            'git'
      recipe            'hive'
      recipe            'java::sun'
      recipe            'jpackage'
      recipe            'jruby'
      recipe            'nodejs'
      recipe            'ntp'
      recipe            'openssh'
      recipe            'openssl'
      recipe            'rstats'
      recipe            'runit'
      recipe            'thrift'
      recipe            'xfs'
      recipe            'xml'
      recipe            'zabbix'
      recipe            'zlib'
    end
  end

  facet :gordo do
    extend ElRidiculoso
    instances           1

    master_processes
    worker_processes
    client_processes
    simple_installs
  end

  facet :jefe do
    extend ElRidiculoso
    instances           1

    master_processes
    simple_installs
  end

  # Runs worker processes and client packages
  facet :bobo do
    extend ElRidiculoso
    instances           1

    worker_processes
    client_processes
    simple_installs
  end

  facet :pequeno do
    role :jruby
    role :pig
    role :elasticsearch_server
    role :elasticsearch_client
    role :hadoop_namenode
    role :hadoop_sencondarynn
    role :hadoop_jobtracker
    role :hadoop_datanode
    role :hadoop_tasktracker
    role :tuning, :last
  end


  cluster_role.override_attributes({
      :apache         => {
        :server       => { :run_state => [:stop, :disable] }, },
      :cassandra      => { :run_state => :stop  },
      :chef           => {
        :client       => { :run_state => :stop  },
        :server       => { :run_state => :stop  }, },
      :elasticsearch  => { :run_state => :stop  },
      :flume          => {
        :master       => { :run_state => :stop  },
        :agent        => { :run_state => :stop  }, },
      :ganglia        => {
        :agent        => { :run_state => :stop  },
        :server       => { :run_state => :stop  }, },
      :graphite       => {
        :carbon       => { :run_state => :stop  },
        :whisper      => { :run_state => :stop  },
        :dashboard    => { :run_state => :stop  }, },
      :hadoop         => {
        :java_heap_size_max => 128,
        :namenode     => { :run_state => :stop  },
        :secondarynn  => { :run_state => :stop  },
        :jobtracker   => { :run_state => :stop  },
        :datanode     => { :run_state => :stop  },
        :tasktracker  => { :run_state => :stop  },
        :hdfs_fuse    => { :run_state => :stop  }, },
      :hbase          => {
        :master       => { :run_state => :stop  },
        :regionserver => { :run_state => :stop  },
        :thrift       => { :run_state => :stop  },
        :stargate     => { :run_state => :stop  }, },
      :jenkins        => {
        :server       => { :run_state => :stop  },
        :worker       => { :run_state => :stop  }, },
      :minidash       => { :run_state => :stop  },
      :mongodb        => {
        :server       => { :run_state => :stop  }, },
      :mysql          => {
        :server       => { :run_state => :stop  }, },
      :nginx          => {
        :server       => { :run_state => :stop  }, },
      :redis          => {
        :server       => { :run_state => :stop  }, },
      :resque         => {
        :redis        => { :run_state => :stop  },
        :dashboard    => { :run_state => :stop  }, },
      :statsd         => { :run_state => :stop  },
      :zabbix         => {
        :agent        => { :run_state => :stop  },
        :master       => { :run_state => :stop  }, },
      :zookeeper      => {
        :server       => { :run_state => :stop  }, },
    })

end
