maintainer        "Infochimps, Inc."
maintainer_email  "coders@infochimps.com"
license           "Apache 2.0"
description       "Install and run an Apache Kafka server"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

depends 'git'
depends 'silverware'
depends 'java'
depends 'runit'
depends 'zookeeper'
depends 'install_from'
depends 'cloud_utils'

recipe "kafka::default", "Base configuration for kafka"
recipe "kafka::contrib", "Kafka Contrib runners"
recipe "kafka::install_from_release", "installs Kafka"
recipe "kafka::server", "installs Kafka, starts a broker, and announces itself"

%w{ debian ubuntu centos redhat fedora scientific amazon }.each do |os|
  supports os
end

attribute "kafka/version",
  :display_name => "Kafka version",
  :description => "The version of Kafka to pull and use",
  :default => "0.7.1_incubating-1"

attribute "kafka/home_dir",
  :display_name => "Kafka home directory",
  :description => "Location for Kafka to be located.",
  :default => "/usr/local/share/kafka"

attribute "kafka/data_dir",
  :display_name => "Kafka data directory",
  :description => "Location for Kafka data.",
  :default => "/var/kafka"

attribute "kafka/log_dir",
  :display_name => "Kafka log directory",
  :description => "Location for Kafka logs.",
  :default => "/var/log/kafka"

attribute "kafka/broker_id",
  :display_name => "Kafka broker ID",
  :description => "The ID of the broker. This must be set to a unique 32-bit integer for each broker. If not set, it defaults to a truncated version of the machine's ip address without the '.'.",
  :default => ""

attribute "kafka/broker_host_name",
  :display_name => "Kafka host name",
  :description => "Hostname the broker will advertise to consumers. If not set, kafka will use the host name for the server being deployed to.",
  :default => ""

attribute "kafka/port",
  :display_name => "Kafka port",
  :description => "The port the broker will listen on.",
  :default => "9092"

attribute "kafka/threads",
  :display_name => "Kafka threads",
  :description => "The number of processor threads the broker uses for receiving and answering requests. If not set, defaults to the number of cores on the machine.",
  :default => ""

attribute "kafka/log_flush_interval",
  :display_name => "Kafka flush interval",
  :description => "The number of messages to accept before forcing a flush of data to disk.",
  :default => "10000"

attribute "kafka/log_flush_time_interval",
  :display_name => "Kafka flush time interval",
  :description => "The maximum amount of time in milliseconds a message can sit in a log before we force a flush.",
  :default => "1000"

attribute "kafka/log_flush_scheduler_time_interval",
  :display_name => "Kafka flush scheduler time interval",
  :description => "The interval in milliseconds at which logs are checked to see if they need to be flushed to disk.",
  :default => "1000"

attribute "kafka/log_retention_hours",
  :display_name => "Kafka log retention hours",
  :description => "The minimum age of a log file in hours to be eligible for deletion",
  :default => "168"
