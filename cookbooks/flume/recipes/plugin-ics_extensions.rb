#
# Cookbook Name::       flume
# Description::         Infochimps Helper Plugins
# Recipe::              plugin-ics_helpers
# Author::              Josh Bronson - Infochimps, Inc
#
# Copyright 2012, Infochimps, Inc.
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

bash "install_ics_extesnsions" do
  node[:flume][:user]
  # "Why do it this way?" Certain maven goals, like the
  # copy-dependencies goal used in this pom, require projects to be
  # executed. I looked for a standalone goal that could be used
  # without a project, and I eventually stumbled across the one used
  # within the opscode maven cookbook: the maven-dependency-plugin:get
  # goal (or Mojo, or whatever). Unfortunately, that goal appears to
  # simply copy the artifact itself to the target directory. The
  # "transitive" option, which is true by default, appears to ensure
  # that all dependencies are installed in the local repository. The
  # command below, once the pom lives on the server, will copy the
  # artifact and all of its dependencies into the flume lib directory.
  #
  # That ought to be enough to discourage you. But if it isn't, the
  # next step down the rabbit hole is to confirm that the get goal
  # doesn't install dependencies. If it does install them, the get
  # goal is absolutely what we want instead.
  code "mvn -f #{node[:flume][:ics_extensions_pom]} install"
end
