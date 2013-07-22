#!/bin/bash

/usr/bin/sv force-stop elasticsearch
echo "Sleeping 60 seconds to ensure elasticsearch is stopped!"
sleep 60

umount <%= node[:ebs_migrate][:es][:mount_point] %>
sleep 5

/usr/local/sbin/ebs_migrate.rb
echo "Sleeping 30 seconds to allow Linux / AWS some time to figure itself out"
sleep 30

<% if node[:ebs_migrate][:es][:mount_cmd] -%>
MOUNT_CMD='<%= node[:ebs_migrate][:es][:mount_cmd] %>'
echo "Mounting device with "${MOUNT_CMD}""
${MOUNT_CMD}
<% end -%>

/etc/init.d/elasticsearch start
