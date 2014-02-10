#
# Cookbook Name:: storm
# Description:: Default configuration for Storm
# Recipe:: default
#

include_recipe 'silverware'

# Storm log storage on a single scratch dir
volume_dirs('storm.log') do
  type          :local
  selects       :single
  path          'storm/log'
  group         'storm'
  mode          "0777"
end