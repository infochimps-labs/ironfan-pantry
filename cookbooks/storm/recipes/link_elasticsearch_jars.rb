#
# Cookbook Name:: storm
# Description:: link elasticsearch jars to storm/lib
# Recipe:: link_elasticsearch_jars
#

Dir[ "#{@node[:elasticsearch][:home_dir]}/lib/*.jar" ].each do |curr_path|
  link "#{@node[:storm][:home_dir]}/lib/#{Pathname.new(curr_path).basename}" do
    to "#{Pathname.new(curr_path).to_s}"
  end if File.file?(curr_path)
end

