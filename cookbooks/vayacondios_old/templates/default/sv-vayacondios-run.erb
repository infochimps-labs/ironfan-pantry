#!/bin/bash

exec 2>&1

export RACK_ENV=<%= node[:vayacondios_old][:server][:environment] %>
export RAILS_ENV=<%= node[:vayacondios_old][:server][:environment] %>
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

cd <%= node[:vayacondios_old][:home_dir] %>
exec chpst -u <%= node[:vayacondios_old][:user] %> \
    bundle exec vcd-server <%= '--verbose' if node[:vayacondios_old][:server][:verbose] %> \
    --environment <%= node[:vayacondios_old][:server][:environment] %> \
    --socket <%= @options[:socket] %> \
    --stdout \
    --host <%= @options[:host] %> \
    --mongo_port <%= @options[:mongo_port] %> \
    --database <%= node[:vayacondios_old][:mongodb][:database] %> \
    --connections <%= node[:vayacondios_old][:mongodb][:connections] %>
