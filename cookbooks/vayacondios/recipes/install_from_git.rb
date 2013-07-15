gem_package "bundler" do
  action :install
end

#git_private_repo "vayacondios_github" do
#  action :ssh_wrapper
#end

shared_env = {
  "RAILS_ENV" => node[:vayacondios][:environment],
  "RACK_ENV"  => node[:vayacondios][:environment],

  # We have to set the LANG environment variable here b/c some
  # gemspecs (lookin' at you devise) have UTF chars in them
  # even though the OS thinks they are ASCII.  Ruby trusts the
  # OS unless you let it know via this variable to trust you
  # instead.  See
  #
  #   https://github.com/carlhuda/bundler/issues/1570
  #
  "LANG" => "en_US.UTF-8",
  "LC_ALL" => "en_US.UTF-8"
}

deploy_revision node[:vayacondios][:deploy_root] do

  action node[:vayacondios][:deploy_strategy].to_sym

  repo              node[:vayacondios][:git_url]
#  ssh_wrapper       '/etc/deploy/vayacondios_github/vayacondios_github.sh'
  branch            node[:vayacondios][:deploy_version]
  enable_submodules false
  shallow_clone     true

  environment shared_env

  symlink_before_migrate "config/vayacondios.yaml" => "config/vayacondios.yaml"

  before_migrate do
    current_release = release_path
    bash "bundle install vayacondios" do
      cwd         current_release
      environment shared_env
      code        "bundle install --without development test"
    end
  end
  migrate false                 # mongo, baby

  before_symlink do
  end

  after_restart do
  end

  restart_command "sv restart vayacondios"
end

