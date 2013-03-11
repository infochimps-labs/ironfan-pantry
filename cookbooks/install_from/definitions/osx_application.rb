
$ws_user ||= 'flip'

#
# Uses install_from to install an OSX Application.
#
# Assumes $ws_user has been set
#
define(:osx_application,
  :user       => $ws_user      # user to install as
) do

  node[:chimpstation_pkg][params[:name]].each{|k,v| params[k.to_sym] = v unless params.has_key?(k.to_sym) }

  params[:app_name]    = File.basename(params[:app_path])
  params[:install_dir] = "/tmp/chimpstation_pkg/#{params[:app_name]}"

  install_from_release(params[:name]) do
    release_url   params[:release_url]
    install_dir   params[:install_dir]
    user          params[:user]
    home_dir      File.dirname(params[:app_path])
    version       params[:version]
    action        :unpack
    not_if{ ::File.exists?(params[:app_path]) }
  end

  bash "Copy #{params[:app_name]} to #{File.dirname(params[:app_path])}" do
    code          %Q{mv '#{params[:install_dir]}' '#{params[:app_path]}'}
    user          params[:user]
    not_if{ ::File.exists?(params[:app_path]) }
  end

end
