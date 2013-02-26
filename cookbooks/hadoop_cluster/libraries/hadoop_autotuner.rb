module HadoopCluster
  #
  # Tune cluster settings for size of instance
  #
  # Called by `attributes/default.rb`, and not by you.
  #
  def set_hadoop_tunables!
    tunables = autotuner_profile || reasonable_guess_profile
    tunables[:java_child_ulimit] = 2 * 1024 * [tunables[:map_heap_mb], tunables[:reduce_heap_mb]].max
    tunables[:aws]               = node[:aws].to_hash if node[:aws]
    #
    Chef::Log.debug("Hadoop tunables: #{tunables.inspect}")
    tunables.each do |attr, val|
      default[:hadoop][attr] = val
    end
  end

  # java_opts += "-Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=#{node[:hadoop][:jmx_dash_addr]} -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"
  # -agentlib:hprof=cpu=samples,interval=1,file=<outputfilename>

  # tunables[:namenode_heap]    = (node[:hadoop][:namenode][:run_state] =~ /start/) ? node[:hadoop][:namenode][:java_heap_size_max]    : 0
  # tunables[:secondarynn_heap] = (node[:hadoop][:namenode][:run_state] =~ /start/) ? node[:hadoop][:namenode][:java_heap_size_max]    : 0
  # tunables[:jobtracker_heap]  = (node[:hadoop][:namenode][:run_state] =~ /start/) ? node[:hadoop][:jobtracker][:java_heap_size_max]  : 0
  # tunables[:datanode_heap]    = (node[:hadoop][:namenode][:run_state] =~ /start/) ? node[:hadoop][:datanode][:java_heap_size_max]    : 0
  # tunables[:tasktracker_heap] = (node[:hadoop][:namenode][:run_state] =~ /start/) ? node[:hadoop][:tasktracker][:java_heap_size_max] : 0

  #
  # Memory-heavy machines are biased towards reduce efficiency; CPU-heavy machines
  # are biased towards mapper efficiency.
  #
  # See ec2-pricing_and_capacity.numbers for calculations
  #
  HADOOP_AUTOTUNER_KEYS = [
    :max_map_tasks, :max_reduce_tasks, :map_heap_mb, :reduce_heap_mb,
    :hdfs_block_size, :io_sort_mb, :adj_shuffle_heap_frac,
    :dn_java_heap_size_max, :tt_java_heap_size_max, :java_stack_size, :tweak_jvm ]
  HADOOP_AUTOTUNER_VALUES = {
    #               maps reds  map mb red mb  block_size     io.s.mb .fctr   dn   tt  stck
    ec2_t1_micro:      [   1,   1,    200,   200, ( 64 * megabyte), 113, 0.70,   96,  96  160,       ], # amusement purposes only
    ec2_m1_small:      [   2,   1,    288,   288, ( 92 * megabyte), 162, 0.70,   96, 192  160,       ], #
    ec2_m1_medium:     [   2,   1,    400,  1200, (128 * megabyte), 226, 0.70,  384, 256  160,       ], #
    ec2_c1_medium:     [   2,   1,    288,   288, ( 92 * megabyte), 162, 0.70,   96, 192  160,       ], #
    ec2_m1_large:      [   3,   1,    800,  2500, (192 * megabyte), 339, 0.85,  384, 384  256, true, ], # Light use, or if best choice if main bottleneck is s3 bandwidth
    ec2_m2_xlarge:     [   3,   2,   1200,  4000, (384 * megabyte), 678, 0.95,  500, 384  256, true, ], #
    ec2_m1_xlarge:     [   4,   2,    800,  3000, (256 * megabyte), 452, 0.95,  500, 384  256, true, ], # General-purpose
    ec2_m3_xlarge:     [   5,   3,    800,  1800, (256 * megabyte), 452, 0.70,  500, 384  256, true, ], #
    ec2_c1_xlarge:     [   9,   2,    384,   520, (128 * megabyte), 226, 0.70,  384, 384  256, true, ], # CPU-intensive map-side jobs. Note the very small reducer capacity; use an m3.xl or m3.2xl if that's an issue
    ec2_m2_2xlarge:    [   5,   3,   1200,  4000, (384 * megabyte), 678, 0.95,  500, 384  256, true, ], #
    ec2_m3_2xlarge:    [   8,   5,    800,  3000, (256 * megabyte), 452, 0.95,  384, 384  256, true, ], # CPU-intensive jobs
    #
    ec2_cc1_4xlarge:   [   9,   5,    800,  1800, (256 * megabyte), 452, 0.70,  384, 384  256, true, ], # bigass data; cpu heavy
    ec2_m2_4xlarge:    [   9,   6,   1200,  4000, (384 * megabyte), 678, 0.95,  500, 384  256, true, ], # bigass data; memory heavy
    ec2_cc2_8xlarge:   [  16,  10,   1200,  2500, (384 * megabyte), 678, 0.85,  500, 384  256, true, ], # bigass data; cpu heavy
    # If you're using these special-purpose machines you're on your own. These
    # settings are extremely conservative, cribbed from the EMR defaults
    ec2_cg1_4xlarge:   [  12,   3,    800,  1200, (128 * megabyte), 226, 0.70,  500, 384  256, true, ], # special-purpose
    ec2_hi1_4xlarge:   [  24,   6,   1400,  1600, (128 * megabyte), 226, 0.70, 1000, 384  256, true, ], # special-purpose
    ec2_hs1_8xlarge:   [  24,   6,   1400,  2500, (128 * megabyte), 226, 0.70, 1000, 384  256, true, ], # special-purpose
    #
    # HBase
    #
    ec2_hb_m1_large:   [   2,   1,    400,   700, (128 * megabyte), 226, 0.70,  800, 384, 256, true, ], # light hbase cluster
    ec2_hb_m1_xlarge:  [   2,   1,    400,   700, (128 * megabyte), 226, 0.70,  800, 384, 256, true, ], # 2-50TB hbase cluster
    ec2_hb_m2_2xlarge: [   3,   1,    400,   700, (128 * megabyte), 226, 0.70,  800, 384, 256, true, ], # 2-50TB hbase cluster
    # note: for HBase, node sizes larger than 30-40GB are not effective -- a regionserver heap size over say 12GB is dangerous (GC pause times).
  }

  def autotuner_profile
    case
    when node[:hadoop][:autotune]
      profile_name = node[:hadoop][:autotune]
    when (node[:ec2] && node[:ec2][:instance_type])
      profile_name = 'ec2_' + node[:ec2][:instance_type].gsub!(/\./, '_')
      Chef::Log.info("No Hadoop Autotuner profile set, using instance size: #{profile_name}")
    else
      Chef::Log.info("No Hadoop Autotuner profile set!")
      return
    end
    Hash[ HADOOP_AUTOTUNER_KEYS.zip(HADOOP_AUTOTUNER_VALUES[profile_name]).to_sym ]
  end

  def reasonable_guess_profile
    cores, ram = cores_and_ram
    Chef::Log.warn("Couldn't set performance parameters: estimating from #{cores} cores and #{ram} ram")
    heap_size = 0.50 * (tunables[:ram].to_f / 1000) / (n_mappers + n_reducers)
    heap_size = [200, heap_size.to_i].max
    {
      max_map_tasks:         ((tunables[:cores] >= 3) ? (tunables[:cores] +  1 ) : tunables[:cores]).to_i,
      max_reduce_tasks:      ((tunables[:cores] >= 2) ? (tunables[:cores] * 0.6) : 1               ).to_i,
      map_heap_mb:           heap_size,
      reduce_heap_mb:        heap_size,
      hdfs_block_size:       128,
      io_sort_mb:            heap_size / 2.0,
      adj_shuffle_heap_frac: 0.70,
      dn_java_heap_size_max: 384,
      tt_java_heap_size_max: 384,
      java_stack_size:       200,
    }
  end

  #
  # Grab machine number-of-cores & ram size, or stuff in defaults if unclear
  #
  def cores_and_ram
    if node[:memory] && node[:cpu]
      cores = node[:cpu   ][:total].to_i
      ram   = node[:memory][:total].to_f
      if node[:memory][:swap] && node[:memory][:swap][:total]
        ram -= node[:memory][:swap][:total].to_f
      end
    else
      Chef::Log.warn("No access to system info (#{node[:memory]} / #{node[:cores]}), using cores=1 memory=1024m. Fix your Ohai settings.")
      cores = 1
      ram   = 1024
    end
    [cores, ram]
  end
end
class Chef::Node              ; include HadoopCluster ; end
