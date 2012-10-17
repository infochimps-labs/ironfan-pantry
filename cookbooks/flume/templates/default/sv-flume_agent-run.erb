#!/bin/bash
exec 2>&1

export JAVA_HOME="<%= node[:java][:java_home] %>"
export FLUME_HOME="<%=     @options[:home_dir] %>"
export FLUME_CONF_DIR="<%= @options[:conf_dir] %>"
export FLUME_LOG_DIR="<%=  @options[:log_dir] %>"
export FLUME_PID_DIR="<%=  @options[:pid_dir] %>"
export FLUME_RUN="<%=      @options[:pid_dir] %>"
export FLUME_IDENT_STRING="<%= @options[:user] %>"
export SERVER_NAME="<%=   node.name.gsub(/[^\w\-]+/, '') %>"
export CLASSPATH=$CLASSPATH:$JAVA_HOME/lib/*:$FLUME_HOME/plugins/*
# export ZOOKEEPER_HOME=""

command=<%= @options[:service_command] %>

export FLUME_PID=${FLUME_PID_DIR}/flume-$FLUME_IDENT_STRING-${command}.pid
export FLUME_LOGFILE=flume-$FLUME_IDENT_STRING-${command}-$SERVER_NAME.log

export FLUME_ROOT_LOGGER="INFO,DRFA"
export ZOOKEEPER_ROOT_LOGGER="INFO,zookeeper"
export WATCHDOG_ROOT_LOGGER="INFO,watchdog"
# log=$FLUME_LOG_DIR/flume-$FLUME_IDENT_STRING-$command-$SERVER_NAME.out
# pid=$FLUME_PID_DIR/flume-$FLUME_IDENT_STRING-$command.pid

ulimit -n <%= @options[:file_limit] %>

export UOPTS="<%= @options[:uopts] %>"

cd "$FLUME_HOME"
exec chpst -u "<%= @options[:user] %>" \
  "${FLUME_HOME}"/bin/flume ${command}_nowatch -n "$SERVER_NAME" "$@" < /dev/null

#   --config $FLUME_CONF_DIR             \
#   
# java \
#   -Dflume.log.dir=/var/log/flume \
#   -Dflume.log.file=flume-flume-node-ip-10-98-142-207.log \
#   -Dflume.root.logger=INFO,DRFA \
#   -Dzookeeper.root.logger=INFO,zookeeper \
#   -Dwatchdog.root.logger=INFO,watchdog \
#   -Djava.library.path=/usr/lib/flume/lib::/usr/lib/hadoop/lib/native/Linux-amd64-64 \
#   -Djruby.home=/usr/local/share/jruby \
#   -Djruby.lib=/usr/local/share/jruby/lib \
#   -Djruby.script=jruby \
#   com.cloudera.flume.agent.FlumeNode -n weatherlight-collector-0


# java -Dflume.log.dir=/var/log/flume/agent -Dflume.log.file=flume-root-node-weatherlight-collector-0.log -Dflume.root.logger=INFO,DRFA -Dzookeeper.root.logger=INFO,zookeeper -Dwatchdog.root.logger=INFO,watchdog -Djava.library.path=/usr/lib/flume/lib::/usr/lib/hadoop/lib/native/Linux-amd64-64 -Djruby.home=                        -Djruby.lib=/lib                        -Djruby.script=jruby com.cloudera.flume.agent.FlumeNode -n weatherlight-collector-0 # us
# java -Dflume.log.dir=/var/log/flume       -Dflume.log.file=flume-flume-node-ip-10-98-142-207.log        -Dflume.root.logger=INFO,DRFA -Dzookeeper.root.logger=INFO,zookeeper -Dwatchdog.root.logger=INFO,watchdog -Djava.library.path=/usr/lib/flume/lib::/usr/lib/hadoop/lib/native/Linux-amd64-64 -Djruby.home=/usr/local/share/jruby  -Djruby.lib=/usr/local/share/jruby/lib  -Djruby.script=jruby com.cloudera.flume.agent.FlumeNode -n weatherlight-collector-0 # orig
