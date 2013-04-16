#
# Backups
#

default[:backups][:location]	= "/mnt/backups" 

#
# S3
#

default[:backups][:s3]		= nil

#
# Namenode
#

default[:backups][:namenode][:cluster_name]	= "hadoop"
default[:backups][:namenode][:minute      ]     = "*/30"
default[:backups][:namenode][:hour        ]     = "*"
default[:backups][:namenode][:day         ]	= "*"
default[:backups][:namenode][:month       ]	= "*" 
default[:backups][:namenode][:weekday     ] 	= "*"

#
# HBase
#

default[:backups][:hbase][:cluster_name            ]     = "hbase"
default[:backups][:hbase][:conf                    ]     = "/etc/hbase_backup.yaml" # YAML for cleanup 
default[:backups][:hbase][:full                    ]     = ["Sunday"]
default[:backups][:hbase][:differential            ]     = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
default[:backups][:hbase][:incrimental             ]     = []
default[:backups][:hbase][:tables                  ]     = '"*"' # Will also accept a list.  ["table1", "table2"]
default[:backups][:hbase][:versions                ]     = "2147483647"
default[:backups][:hbase][:minute                  ]     = "0"
default[:backups][:hbase][:hour                    ]     = "2"
default[:backups][:hbase][:day                     ]     = "*"
default[:backups][:hbase][:month                   ]     = "*"
default[:backups][:hbase][:weekday                 ]     = "*"
default[:backups][:hbase][:retention][:full        ]     = "5"    
default[:backups][:hbase][:retention][:differential]     = "10"
default[:backups][:hbase][:retention][:incrimental ]     = "0"


#
# Zookeeper
#

default[:backups][:zookeeper][:cluster_name]     = "zookeeper"
default[:backups][:zookeeper][:minute      ]     = "*/30"
default[:backups][:zookeeper][:hour        ]     = "*"
default[:backups][:zookeeper][:day         ]     = "*"
default[:backups][:zookeeper][:month       ]     = "*"
default[:backups][:zookeeper][:weekday     ]     = "*"

#
# Elasticsearch
#

default[:backups][:elasticsearch][:cluster_name]     = "elasticsearch"
default[:backups][:elasticsearch][:scroll      ]     = "1000"
default[:backups][:elasticsearch][:indexes     ]     = ["_all"]
default[:backups][:elasticsearch][:minute      ]     = "0"
default[:backups][:elasticsearch][:hour        ]     = "4"
default[:backups][:elasticsearch][:day         ]     = "*"
default[:backups][:elasticsearch][:month       ]     = "*"
default[:backups][:elasticsearch][:weekday     ]     = "0"

#
# MongoDB
#

default[:backups][:mongodb][:minute      ]     = "0"
default[:backups][:mongodb][:hour        ]     = "4"
default[:backups][:mongodb][:day         ]     = "*/3"
default[:backups][:mongodb][:month       ]     = "*"
default[:backups][:mongodb][:weekday     ]     = "*"

#
# EBS
#

default[:backups][:ebs][:minute    ]     = "0"
default[:backups][:ebs][:hour      ]     = "2"
default[:backups][:ebs][:day       ]     = "*"
default[:backups][:ebs][:month     ]     = "*"
default[:backups][:ebs][:weekday   ]     = "*"
#default[:backups][:ebs][:xfs_freeze]     = nil
default[:backups][:ebs][:xfs_freeze]     = "/usr/sbin/xfs_freeze"

#
# Retention
# 

default[:backups][:retention][:minute       ]     = "0"
default[:backups][:retention][:hour         ]     = "4"
default[:backups][:retention][:day          ]     = "*"
default[:backups][:retention][:month        ]     = "*"
default[:backups][:retention][:weekday      ]     = "*"
default[:backups][:retention][:namenode     ]     = "7"  # Retention in days
default[:backups][:retention][:zookeeper    ]     = "5"  # Retention in days
default[:backups][:retention][:mongodb      ]     = "14" # Retention in days
default[:backups][:retention][:elasticsearch]     = "7"  # Number of backups to keep
default[:backups][:retention][:ebs]               = "7"  # Number of ebs backups to keep
