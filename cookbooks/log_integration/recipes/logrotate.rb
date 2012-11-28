package "logrotate"

# Rotate hourly, in case we have fast-moving logs we want to expire quickly
bash "run logrotate every hour" do
  code "mv /etc/cron.daily/logrotate /etc/cron.hourly/logrotate"
  creates "/etc/cron.hourly/logrotate"
end

# Iterate over ever component with a log aspect...
components_with(:logs).each do |component|
  
  # ... and over each log aspect for the component...
  component.logs.each_pair do |aspect_name, aspect_props|

    # Now we figure out the paths to the actual log files that will
    # need to be rotated by lograted for this aspect.
    aspect_props = { :path => aspect_props } unless aspect_props.is_a?(Hash)

    # Skip if we need to
    next if aspect_props[:logrotate] == false || aspect_props[:ignore] == true
    
    given_path = aspect_props[:path]
    case
    when aspect_props[:glob]
      rel_path = File.dirname(aspect_props[:glob])
      log_path = Dir[aspect_props[:glob]].map { |path| '"' + path + '"' }.join(' ')
    when !File.exist?(given_path)
      Chef::Log.warn("Could not find a log file/directory at #{given_path} to logrotate, skipping...")
      next
    when File.directory?(given_path)
      rel_path = given_path
      log_path = "#{given_path}/*.log"
    else
      rel_path = File.dirname(given_path)
      log_path = given_path
    end

    # Construct the name of the file.
    config_basename = "#{node.log_integration.logrotate.conf_prefix}#{component.fullname}-#{aspect_name}"
    config_path     = File.join(node.log_integration.logrotate.conf_dir, config_basename)

    # Construct the options for the template
    options = node.log_integration.logrotate.to_hash
    aspect_props.each_pair { |k, v| options[k.to_s] = v }
    formatted_options  = []
    options.each_pair do |name, value|
      # Ignore the non-logrotate options we've jammed into the Hash...
      next if %w[path conf_prefix conf_dir logrotate].include?(name.to_s)
      
      # Let helper format the actual option text
      line = (logrotate_option(name, value) || logrotate_option(name, value.to_s))
      formatted_options << line if line
    end

    # Need to make sure old directory still exists.
    if options['olddir']
      directory File.expand_path(options['olddir'], rel_path) do
        action :create
      end
    end

    # Create the file.
    template config_path do
      source    'logrotate.erb'
      mode      '0644'
      variables :options => formatted_options, :path => log_path
    end
  end
end
