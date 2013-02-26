module HadoopCluster
  # installs given hadoop package using the configured deb version
  def hadoop_package component
    package_name = (component ? "#{node[:hadoop][:handle]}-#{component}" : "#{node[:hadoop][:handle]}")
    package package_name do
      if node[:hadoop][:deb_version] != 'current'
        version node[:hadoop][:deb_version]
      end
    end
  end

  # the hadoop services this machine provides
  def hadoop_services
    %w[namenode secondarynn jobtracker datanode tasktracker].select do |svc|
      node[:announces]["#{node[:cluster_name]}-hadoop-#{svc}"]
    end
  end

  # hash of hadoop options suitable for passing to template files
  def hadoop_config_hash
    if node[:hadoop][:java_child_opts] then
      Chef::Log.warn %Q{=> node[:hadoop][:java_child_opts] is no longer used. Set your memory usage with :map_heap_mb and :reduce_heap_mb, and other java options with :java_extra_child_opts}
    end
    hsh = Mash.new()
    hsh[:extra_classpaths]  = node[:hadoop][:extra_classpaths].map{|nm, classpath| classpath }.flatten
    hsh.merge!(child_java_opts)
    hsh.merge!(node[:hadoop].to_hash)
    hsh
  end

  def child_java_opts
    opts = []
    opts << "-Xss#{tunables[:java_stack_size]}"
    opts << "-Xprof -verbose:gc -Xloggc:/tmp/hdp-task-gc-@taskid@.log" if node[:hadoop][:task_profile]
    opts << '-XX:+UseCompressedOops -XX:MaxNewSize=200m -server' if node[:hadoop][:tweak_jvm]
    opts << node[:hadoop][:java_extra_child_opts].to_s
    #
    { :java_map_opts    => "-Xmx#{node[:hadoop][:map_heap_mb]   }m #{opts.join(" ")}"
      :java_reduce_opts => "-Xmx#{node[:hadoop][:reduce_heap_mb]}m #{opts.join(" ")}" }
  end

  # Create a symlink to a directory, wiping away any existing dir that's in the way
  def force_link dest, src
    directory(dest) do
      action :delete ; recursive true
      not_if{ File.symlink?(dest) }
    end
    link(dest){ to src }
  end

end

class Chef::Recipe              ; include HadoopCluster ; end
class Chef::Resource::Directory ; include HadoopCluster ; end
class Chef::Resource::Execute   ; include HadoopCluster ; end
class Chef::Resource::Template  ; include HadoopCluster ; end
class Erubis::Context           ; include HadoopCluster ; end
