maintainer       "Brandon Bell - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "Backups -- coordinates backups of your stuff"

depends		 "hbase"
depends		 "mongodb"
depends		 "hadoop"
depends		 "elasticsearch"

recipe           "backups::default",       "Default Recipe"
recipe           "backups::namenode",      "Namenode Backup Recipe"
recipe           "backups::s3cfg",         "S3 Configuration Recipe"
recipe           "backups::hbase",         "HBase Backup Recipe"
recipe           "backups::zookeeper",     "Zookeeper Backup Recipe"
recipe           "backups::elasticsearch", "Elasticsearch Backup Recipe"
recipe           "backups::mongodb",       "MongoDB backup Recipe"
recipe           "backups::ebs",           "EBS Snapshots"

%w[ debian ubuntu ].each do |os|
  supports os
end

attribute "backups/location",
  :display_name          => "",
  :description           => "Directory in which to backup to",
  :default               => "/mnt/backups"

attribute "backups/namenode/cluster_name",
  :display_name          => "",
  :description           => "",
  :default               => "hadoop"

attribute "backups/hbase/cluster_name",
  :display_name          => "",
  :description           => "",
  :default               => "hbase"

attribute "backups/zookeeper/cluster_name",
  :display_name          => "",
  :description           => "",
  :default               => "zookeeper"

attribute "backups/elasticsearch/cluster_name",
  :display_name          => "",
  :description           => "",
  :default               => "elasticsearch"

