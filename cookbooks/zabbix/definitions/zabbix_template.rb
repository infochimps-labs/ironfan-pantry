# It's tricky to idempotently upload templates to Zabbix.
#
# A template on disk is an XML file.  Zabbix eats that XML file and
# turns it into rows all over the place in its database.  You can ask
# Zabbix to export a template it knows about but there's no guarantee
# that what you get will be (syntactically) the same as what you
# uploaded, making using checksums difficult.
#
# We use a sneaky trick here: we first create a cookbook_file
# containing the XML to be stored on disk locally.  We then attach a
# notifier to this cookbook_file to run the zabbix_template_upload
# resource.
#
# Since the "template we uploaded" should be the same as the "template
# on disk", whenever the one on disk is updated (idempotently) by
# Chef, we should also upload again.
define :zabbix_template, :server => nil, :cookbook => nil, :update_hosts => nil, :add_hosts => nil, :update_items => nil, :add_items => nil, :update_triggers => nil, :add_triggers => nil, :update_graphs => nil, :add_graphs => nil, :update_templates => nil do

  # Where to stash the templates locally.
  directory "/etc/zabbix/templates" do
    action :create
  end

  # No action by default.
  zabbix_template_upload params[:name] do
    server           params[:server]
    cookbook         params[:cookbook]
    update_hosts     params[:update_hosts]
    add_hosts        params[:add_hosts]
    update_items     params[:update_items]
    add_items        params[:add_items]
    update_triggers  params[:update_triggers]
    add_triggers     params[:add_triggers]
    update_graphs    params[:update_graphs]
    add_graphs       params[:add_graphs]
    update_templates params[:update_templates]
    action           :nothing
  end

  # Create the cookbook_file, notifying the zabbix_template_upload if
  # necessary.
  cookbook_file "/etc/zabbix/templates/#{params[:name]}" do
    mode     '0644'
    action   :create
    notifies :upload, "zabbix_template_upload[#{params[:name]}]", :immediately
  end
end
