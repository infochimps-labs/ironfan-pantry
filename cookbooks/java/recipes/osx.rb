
node.set['java']['java_home'] = "/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home"

Chef::Log.warn "Skipping Java install because you're on OSX, hope the system java at #{node[:java][:java_home]} is good enough for you."
