#!/bin/bash
exec 2>&1

export JAVA_HOME="<%=          node[:java][:java_home] %>"
export FLUME_HOME="<%=         @options[:home_dir] %>"
export FLUME_CONF_DIR="<%=     @options[:conf_dir] %>"
export FLUME_LOG_DIR="<%=      @options[:log_dir] %>"
export FLUME_PID_DIR="<%=      @options[:pid_dir] %>"
export FLUME_RUN="<%=          @options[:pid_dir] %>"
export FLUME_IDENT_STRING="<%= @options[:user] %>"
export SERVER_NAME="<%=        node.name.gsub(/[^\w\-]+/, '') %>-agent-<%= @options[:daemon_index] %>"
export CLASSPATH=$CLASSPATH:$JAVA_HOME/lib/*:$FLUME_HOME/plugins/*

command=<%= @options[:service_command] %>

export FLUME_PID=${FLUME_PID_DIR}/flume-$FLUME_IDENT_STRING-${command}-<%= @options[:daemon_index] %>.pid
export FLUME_LOGFILE=flume-$FLUME_IDENT_STRING-${command}-$SERVER_NAME.log

export FLUME_ROOT_LOGGER="INFO,DRFA"
export ZOOKEEPER_ROOT_LOGGER="INFO,zookeeper"
export WATCHDOG_ROOT_LOGGER="INFO,watchdog"

ulimit -n <%= @options[:file_limit] %>

export UOPTS="<%= @options[:uopts] %>"

cd "$FLUME_HOME"
exec chpst -u "<%= @options[:user] %>" \
  "${FLUME_HOME}"/bin/flume ${command}_nowatch -n "$SERVER_NAME" "$@" < /dev/null
