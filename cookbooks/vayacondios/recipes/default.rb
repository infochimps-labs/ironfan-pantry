daemon_user   "vayacondios"

standard_dirs "vayacondios" do
  # do *not* include home_dir as it is actually a symlink that will be
  # created by the deploy_revision block below
  directories :deploy_root, :log_dir, :conf_dir
end

