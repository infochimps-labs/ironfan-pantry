include_recipe 'nginx'
include_recipe 'route53'

standard_dirs :package_server do
  directories :pid_dir
end
