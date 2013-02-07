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
default[:backups][:hbase][:conf                    ]     = "/etc/hbase_backup.yaml"
default[:backups][:hbase][:full                    ]     = ["Sunday"]
default[:backups][:hbase][:differential            ]     = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
default[:backups][:hbase][:incrimental             ]     = []
default[:backups][:hbase][:tables                  ]     = []
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
default[:backups][:elasticsearch][:indexes     ]     = []
default[:backups][:elasticsearch][:minute      ]     = "0"
default[:backups][:elasticsearch][:hour        ]     = "4"
default[:backups][:elasticsearch][:day         ]     = "*"
default[:backups][:elasticsearch][:month       ]     = "*"
default[:backups][:elasticsearch][:weekday     ]     = "0"

