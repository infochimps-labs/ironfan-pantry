mongo = discover(:mongodb, :server)

if node[:cube][:mongodb][:expire_metrics_horizon]
  cron "cube_remove_expired_metrics" do
    hour   "4"
    minute "0"
    command "cd #{node[:cube][:home_dir]} && npm run-script remove_expired_metrics"
  end
end


template File.join(node[:cube][:conf_dir], 'cube.js') do
  source    "cube.js.erb"
  action    :create
  mode      "0644"
  node[:cube][:collector][:instances].times do |idx|
    notifies  :restart, "service[cube_collector_#{idx}]", :delayed
  end
  notifies  :restart, "service[cube_evaluator]", :delayed
  notifies  :restart, "service[cube_warmer]",    :delayed

  variables({
    :mongodb => Mash.new().merge(node[:cube][:mongodb]).merge(:host => mongo.private_ip),
    :collector => node[:cube][:collector],
    :evaluator => node[:cube][:evaluator],
    :warmer    => node[:cube][:warmer] })
end

deploy_revision node[:cube][:deploy_root] do
  action            node[:cube][:deploy_strategy].to_sym
  repo              node[:cube][:git_url]
  branch            node[:cube][:deploy_version]
  enable_submodules true
  shallow_clone     true

  symlink_before_migrate "config/cube.js" => "config/cube.js"

  before_migrate do
    current_release = release_path
    bash "npm install cube" do
      cwd  current_release
      code "npm install node-gyp && npm install mongodb --mongodb:native && npm install"
    end
  end

  migrate false

  before_symlink do
  end

  before_restart do
  end

  after_restart do
  end

  restart_command "sv restart cube_evaluator"
  restart_command "sv restart cube_collector"
  restart_command "sv restart cube_warmer"
end

