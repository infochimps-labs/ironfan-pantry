name             'hadoop'
maintainer       "Philip (flip) Kromer - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
description      "Hadoop: distributed massive-scale data processing framework. Store and analyze terabyte-scale datasets with ease"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

conflicts        'hadoop_cluster'
depends          'runit'
