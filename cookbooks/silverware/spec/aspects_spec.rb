require File.expand_path('spec_helper', File.dirname(__FILE__))
require SILVERWARE_DIR("libraries/silverware")
require SILVERWARE_DIR("libraries/aspects")

describe 'aspect' do
  include_context 'dummy_chef'

  def harvest_klass(component)
    described_class.harvest(chef_context, component)
  end
  let(:component){ hadoop_datanode_component }
  let(:harvested){ harvest_klass(component) }
  let(:subject){   harvested.values.first   }

  describe Ironfan::PortAspect do
    it 'harvests any "*_port" attributes' do
      harvested.should == Mash.new({
          :dash_port     => Ironfan::PortAspect.new(component, "dash_port",      :dash,     "50075"),
          :ipc_port      => Ironfan::PortAspect.new(component, "ipc_port",       :ipc,      "50020"),
          :jmx_dash_port => Ironfan::PortAspect.new(component, "jmx_dash_port", :jmx_dash,  "8006"),
          :port          => Ironfan::PortAspect.new(component, "port",           :port,     "50010"),
        })
    end

    # context '#addrs' do
    #   it 'can be marked :critical, :open, :closed or :ignore'
    #   it 'marks first private interface open by default'
    #   it 'marks other interfaces closed by default'
    # end
    # context '#flavor' do
    #   it 'accepts a defined flavor'
    # end
    # context '#monitors' do
    #   it 'accepts an arbitrary hash'
    # end
  end

  describe Ironfan::DashboardAspect do
    it 'harvests any "dash_port" attributes' do
      harvested.should == Mash.new({
          :dash     => Ironfan::DashboardAspect.new(component, "dash",     :http_dash, "http://33.33.33.12:50075/"),
          :jmx_dash => Ironfan::DashboardAspect.new(component, "jmx_dash", :jmx_dash,  "http://33.33.33.12:8006/"),
        })
    end
    it 'by default harvests the url from the private_ip and dash_port'
    it 'lets me set the URL with an explicit template'
  end

  describe Ironfan::DaemonAspect do
    it 'harvests its associated service resource' do
      harvested.should == Mash.new({
          :hadoop_datanode => Ironfan::DaemonAspect.new(component, "hadoop_datanode", "hadoop_datanode", "hadoop_datanode", 'start'),
        })
    end

    context '#run_state' do
      it 'harvests the :run_state attribute' do
        subject.run_state.should == 'start'
      end
      it 'only accepts :start, :stop or :nothing' do
        chef_node[:hadoop][:datanode][:run_state] = 'shazbot'
        Chef::Log.should_receive(:warn).with("Odd run_state shazbot for daemon hadoop_datanode: set node[:hadoop][:datanode] to :stop, :start or :nothing")
        subject.lint
      end
    end

    # context '#service_name' do
    #   it 'defaults to' do
    #
    #   end
    # end

    # context '#boot_state' do
    #   it 'harvests the :boot_state attribute'
    #   it 'can be set explicitly'
    #   it 'only accepts :enable, :disable or nil'
    # end
    # context '#pattern' do
    #   it 'harvests the :pattern attribute from the associated service resource'
    #   it 'is not settable explicitly'
    # end
    # context '#limits' do
    #   it 'accepts an arbitrary hash'
    #   it 'harvests the :limits hash'
    # end
  end

  describe Ironfan::LogAspect do
    let(:component){ flume_agent_component }
    it 'harvests any "log_dir" attributes' do
      harvested.should == Mash.new({
          :log => Ironfan::LogAspect.new(component, "log", :log, ["/var/log/flume"]),
        })
    end
    # context '#flavor' do
    #   it 'accepts :http, :log4j, or :rails'
    # end
  end

  describe Ironfan::DirectoryAspect do
    let(:component){ flume_agent_component }
    it 'harvests attributes ending with "_dir"' do
      harvested.should == Mash.new({
          :conf => Ironfan::DirectoryAspect.new(component, "conf", :conf, ["/etc/flume/conf"]),
          :data => Ironfan::DirectoryAspect.new(component, "data", :data, ["/data/db/flume"]),
          :home => Ironfan::DirectoryAspect.new(component, "home", :home, ["/usr/lib/flume"]),
          :log  => Ironfan::DirectoryAspect.new(component, "log",  :log,  ["/var/log/flume"]),
          :pid  => Ironfan::DirectoryAspect.new(component, "pid",  :pid,  ["/var/run/flume"]),
        })
    end
    it 'harvests non-standard dirs' do
      chef_node[:flume][:foo_dirs] = ['/var/foo/flume', '/var/bar/flume']
      directory_aspects = harvest_klass(flume_agent_component)
      directory_aspects.should == Mash.new({
          :conf => Ironfan::DirectoryAspect.new(component, "conf", :conf, ["/etc/flume/conf"]),
          :data => Ironfan::DirectoryAspect.new(component, "data", :data, ["/data/db/flume"]),
          :foo  => Ironfan::DirectoryAspect.new(component, "foo",  :foo,  ["/var/foo/flume", "/var/bar/flume"]),
          :home => Ironfan::DirectoryAspect.new(component, "home", :home, ["/usr/lib/flume"]),
          :log  => Ironfan::DirectoryAspect.new(component, "log",  :log,  ["/var/log/flume"]),
          :pid  => Ironfan::DirectoryAspect.new(component, "pid",  :pid,  ["/var/run/flume"]),
        })
    end
    it 'harvests plural directory sets ending with "_dirs"' do
      component = hadoop_namenode_component
      directory_aspects = harvest_klass(component)
      directory_aspects.should == Mash.new({
          :conf => Ironfan::DirectoryAspect.new(component, "conf", :conf, ["/etc/hadoop/conf"]),
          :data => Ironfan::DirectoryAspect.new(component, "data", :data, ["/mnt1/hadoop/hdfs/name", "/mnt2/hadoop/hdfs/name"]),
          :home => Ironfan::DirectoryAspect.new(component, "home", :home, ["/usr/lib/hadoop"]),
          :log  => Ironfan::DirectoryAspect.new(component, "log",  :log,  ["/hadoop/log"]),
          :pid  => Ironfan::DirectoryAspect.new(component, "pid",  :pid,  ["/var/run/hadoop"]),
          :tmp  => Ironfan::DirectoryAspect.new(component, "tmp",  :tmp,  ["/hadoop/tmp"]),
        })
    end

    # it 'finds its associated resource'
    # context 'permissions' do
    #   it 'finds its mode / owner / group from the associated respo'
    # end
    #
    # context '#flavor' do
    #   def good_flavors() [:home, :conf, :log, :tmp, :pid, :data, :lib, :journal, :cache] ; end
    #   it "accepts #{good_flavors}"
    # end
    # context '#limits' do
    #   it 'accepts an arbitrary hash'
    # end
  end

  describe Ironfan::ExportedAspect do
    # context '#files' do
    #   let(:component){ hbase_master_component }
    #   it 'harvests attributes beginning with "exported_"' do
    #     harvested.should == Mash.new({
    #         :confs => Ironfan::ExportedAspect.new(component, "confs", :confs, ["/etc/hbase/conf/hbase-default.xml", "/etc/hbase/conf/hbase-site.xml"]),
    #         :jars  => Ironfan::ExportedAspect.new(component, "jars",  :jars,  ["/usr/lib/hbase/hbase-0.90.1-cdh3u0.jar", "/usr/lib/hbase/hbase-0.90.1-cdh3u0-tests.jar"])
    #       })
    #   end
    # end

    it 'converts flavor to sym' do
      subject.flavor('hi').should == :hi
      subject.flavor.should       == :hi
    end
  end

  # describe Ironfan::CookbookAspect do
  # end
  #
  # describe Ironfan::CronAspect do
  # end

end
