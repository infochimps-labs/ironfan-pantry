include_recipe 'git'
include_recipe 'runit'

Chef::Log.info "deploy keys: #{node[:deploy_keys].to_hash.inspect}"

git_private_repo 'kafka-contrib' do
  action                :ssh_wrapper
  private_keys_contents node[:deploy_keys]
end

shared_env = {'LANG' => 'en_US.UTF-8', 'LC_ALL' => 'en_US.UTF-8'}

Chef::Log.info "kafka-contrib deploy_to #{node[:kafka][:contrib][:deploy][:root]}"

# FIXME: workaround for apparent deploy_revision bug (CHEF-3435, I
# think) that appears to only occur in our 11.04 images: The git
# provider complains that the parent directory does not exist when
# cloning kafka-contrib.
directory File.join(node[:kafka][:contrib][:deploy][:root], 'shared') do
  recursive true
end

deploy_revision node[:kafka][:contrib][:deploy][:root] do
  action                :deploy
  repository            node[:kafka][:contrib][:deploy][:repo]
  branch                node[:kafka][:contrib][:deploy][:branch]
  ssh_wrapper           File.join(node[:git][:deploy_root], 'kafka-contrib/kafka-contrib.sh')
  environment           shared_env
  shallow_clone         true

  before_migrate do
    current_release =   release_path

    bash 'bundle install kafka-contrib' do
      cwd               current_release
      environment       shared_env
      code              'bundle install --path vendor/bundle --without development'
    end

    bash 'maven package kafka-contrib' do
      cwd               current_release
      code              'mvn package -DskipTests=true'
    end
  end
end

contrib_apps = node[:kafka][:contrib][:app].keys.reject{ |key| %w[options daemons group_id topic run_state type].include?(key.to_s) } rescue []

Chef::Log.info "Kafka-contrib apps: #{contrib_apps}"

contrib_apps.each do |app_name|

  Chef::Log.info "Creating Kafka-contrib application \"#{app_name}\""

  run_contrib_app app_name do
    app_type              node[:kafka][:contrib][:app][app_name][:type]
    user                  node[:kafka][:contrib][:app][app_name][:user]
    daemon_count          node[:kafka][:contrib][:app][app_name][:daemons]
    config_file_options   node[:kafka][:contrib][:app][app_name][:config_file_options]
    options               node[:kafka][:contrib][:app][app_name][:options]
    group_id              node[:kafka][:contrib][:app][app_name][:group_id]
    topic                 node[:kafka][:contrib][:app][app_name][:topic]
    run_state             node[:kafka][:contrib][:app][app_name][:run_state]
    kafka_home            node[:kafka][:contrib][:app][app_name][:kafka_home]
  end
end

node[:kafka][:ftp_loader][:sites].each do |name, site|
  if site[:use]
    set_ftp_loader do
      thenode         Mash.new(site.merge(name: name))
      command         node[:kafka][:ftp_loader][:command] 
      code_directory  node[:kafka][:ftp_loader][:code_dir] 
    end
  end
end


