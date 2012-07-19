#
# Cookbook Name::       graphite
# Description::         Web Dashboard
# Recipe::              dashboard
# Author::              Heavy Water Software Inc.
#
# Copyright 2011, Heavy Water Software Inc.
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

include_recipe 'runit'
include_recipe 'install_from'

package "python-cairo-dev"
package "python-django"
package "python-memcache"
package "python-rrdtool"

package "python-django-tagging"
package "python-ldap"
package "python-amqplib"

standard_dirs('graphite.dashboard'){ directories :log_dir }
