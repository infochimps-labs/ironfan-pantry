#!/bin/bash

exec 2>&1

export RACK_ENV=<%= node[:vayacondios][:server][:environment] %>
export RAILS_ENV=<%= node[:vayacondios][:server][:environment] %>
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

cd <%= node[:vayacondios][:home_dir] %>
exec chpst -u <%= node[:vayacondios][:user] %> \
    bundle exec "vcd-server <%= '--verbose' if node[:vayacondios][:server][:verbose] %> \
    --environment <%= node[:vayacondios][:server][:environment] %> \
    <%- if @options[:port] %>
    --port <%= @options[:port] %> \
    <%- else %>
    --socket <%= @options[:socket] %> \
    <%- end %>
    --stdout \
    --database.driver mongo \
    --database.host <%= @options[:host] %> \
    --database.port <%= @options[:mongo_port] %> \
    --database.name <%= node[:vayacondios][:mongodb][:database] %> \
    --database.connections <%= node[:vayacondios][:mongodb][:connections] %>"
