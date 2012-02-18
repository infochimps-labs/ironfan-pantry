
default[:volumes] ||= Mash.new

# where should we get the AWS keys?
default[:silverware][:aws_credential_source] = :data_bag
# the key within that data bag
default[:silverware][:aws_credential_handle] = 'main'
