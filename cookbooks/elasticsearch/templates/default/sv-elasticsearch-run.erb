#!/bin/bash

# Force all stderr to stdout
exec 2>&1

# Where does elasticsearch live?
export ES_HOME=<%= @options[:home_dir] %>
export ES_CONF_DIR=<%= @options[:conf_dir] %>
export ES_INCLUDE=$ES_CONF_DIR/elasticsearch.in.sh
export JAVA_HOME=<%= @options[:java_home] %>

# Where does data live?
export ES_DATA_DIR=<%= @options[:data_dir] %>
export ES_WORK_DIR=<%= @options[:scratch_dir] %>

# bump the # of open files way way up
ulimit -n 65536
<%- unless @options[:ulimit_mlock].nil? %>
# allow elasticsearch to lock itself into memory if JNA is installed
ulimit -l <%= @options[:ulimit_mlock] %>
<%- end %>

ulimit -a

# Force the heap size
<% if @options[:java_heap_size_min] || @options[:java_heap_size_max] %>
export ES_MIN_MEM=<%= @options[:java_heap_size_min] || @options[:java_heap_size_max] %>m
<% end %>
<% if @options[:java_heap_size_max] %>
export ES_MAX_MEM=<%= @options[:java_heap_size_max] %>m
<% end %>
<% if @options[:java_heap_newgen] %>
export ES_HEAP_NEWSIZE=<%= @options[:java_heap_newgen] %>m
<% end %>

sleep 2 # ES will flap flap flap if it crashes on start. Slightly reduces chance that it fills your log dir.

# Run in non-daemonizing mode
cd $ES_HOME
exec chpst -u elasticsearch $ES_HOME/bin/elasticsearch \
  -Des.config=$ES_CONF_DIR/elasticsearch.yml \
  -f 
