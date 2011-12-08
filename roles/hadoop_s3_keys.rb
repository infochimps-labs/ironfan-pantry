name        'hadoop_s3_keys'
description 'Add S3 keys to node attributes for hadoop s3:// and s3n:// filesystem access'

# Attributes applied if the node doesn't have it set already.
default_attributes({
    # Needed if you want to access S3 files via s3n:// and s3:// urls
    :aws => {
      :aws_access_key        => Chef::Config.knife[:aws_access_key_id],
      :aws_access_key_id     => Chef::Config.knife[:aws_access_key_id],
      :aws_secret_access_key => Chef::Config.knife[:aws_secret_access_key],
    },
  })
