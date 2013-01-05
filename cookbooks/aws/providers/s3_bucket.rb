include Opscode::Aws::Ec2

action :create do
  s3.bucket(new_resource.name, true, new_resource.permissions, new_resource.headers)
end

action :destroy do
  the_bucket = s3.bucket(new_resource.name)
  the_bucket.delete(:force => new_resource.force) if the_bucket
end
