# A sample Guardfile -*- ruby -*-
# More info at https://github.com/guard/guard#readme

# # This is an example with all options that you can specify for guard-process
# guard 'process', :name => 'echo', :command => 'echo', :env => {"ENV1" => "value 1", "ENV2" => "value 2"}, :stop_signal => "KILL"  do
#   watch(%r{^homebase/vendor/[^/]+/(.+)}){|m| fn = "cookbooks/#{m[1]}" ; p [m, fn] ; fn }
# end


# run the right knife command on changes within the cookbooks, roles and data_bags directories
guard 'chef' do
  watch(%r{vendor/[^/]+/([\w\-\:\.\/]+)}){|m| fn = "cookbooks/#{m[1]}" ; fn if File.exists?(fn) }
  watch(%r{^.*cookbooks/([\w\-\:\.\/]+)/})
  watch(%r{^roles/([\w\-\:\.\/]+)\.(rb|json)\z})
  watch(%r{^data_bags/([\w\-\:\.\/]+)/})
  watch(%r{^environments/[\w\-\:\.\/]+\.(rb|json)\z})
end
