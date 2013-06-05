#!/bin/bash
exec 2>&1

source /etc/environment

BUNDLE_EXEC="<%= node[:languages][:ruby][:bin_dir] %>/bundle exec"
APP_ROOT="<%= node[:kafka][:contrib][:deploy][:root] %>/current"
KAFKA_CONTRIB="${APP_ROOT}/bin/kafka"
APP="<%= @options[:app_type] %>"
HADOOP_HOME="<%= @options[:hadoop_home] %>"
KAFKA_HOME="<%= @options[:kafka_home] %>"
CONFIG_FILE="${APP_ROOT}/config/<%= @options[:app_name] %>.properties"
TOPIC="<%= @options[:topic] %>"
EXTRA_OPTS="<%= @options[:app_options] %>"

cd $APP_ROOT
exec chpst -u <%= @options[:run_as_user] %> $BUNDLE_EXEC $KAFKA_CONTRIB $APP -f $CONFIG_FILE -t $TOPIC $EXTRA_OPTS --kafka_home=${KAFKA_HOME} --hadoop_home=${HADOOP_HOME}
