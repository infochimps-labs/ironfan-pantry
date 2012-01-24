#
# Cookbook Name::       jruby
# Description::         Gems
# Recipe::              gems
# Author::              Jacob Perkins - Infochimps, Inc
#
# Copyright 2011, Infochimps, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

%w[

    bundler jruby-openssl erubis i18n
    activesupport activemodel extlib
    json addressable cheat crack
    configliere gorillib wukong
    pry hirb ap swineherd

].each do |rubygem|
  gem_package rubygem do
    gem_binary File.join(node[:jruby][:home_dir], 'bin/chef-jgem')
  end
end
