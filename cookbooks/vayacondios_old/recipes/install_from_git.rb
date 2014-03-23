gem_package "bundler" do
  action :install
end

git_private_repo "vayacondios_github" do
  action :ssh_wrapper
  private_keys_contents node[:git_keys]
end

shared_env = {
  "RAILS_ENV" => node[:vayacondios_old][:server][:environment],
  "RACK_ENV"  => node[:vayacondios_old][:server][:environment],

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

deploy_revision node[:vayacondios_old][:deploy_root] do

  action node[:vayacondios_old][:deploy_strategy].to_sym

  repo              node[:vayacondios_old][:git_url]
  ssh_wrapper       '/etc/deploy/vayacondios_github/vayacondios_github.sh'
  branch            node[:vayacondios_old][:git_version]
  enable_submodules false
  shallow_clone     true

  environment shared_env

  before_migrate do
    current_release = release_path
    bash "bundle install vayacondios_old" do
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

  the_restart_command = Dir["/etc/sv/vayacondios_old_*"].map { |sv_dir| "sv restart #{File.basename(sv_dir)}" }.join(" && ")
  restart_command the_restart_command unless the_restart_command.empty?
end

