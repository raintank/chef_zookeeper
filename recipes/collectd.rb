#
# Cookbook Name:: chef_zookeeper
# Recipe:: collectd
#
# Copyright (C) 2016 Raintank, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

directory "/usr/share/collectd/plugins" do
  recursive true
  owner 'root'
  group 'root'
  mode '0755'
  only_if { node['use_collectd'] }
end

package 'python-pip'
package 'python-dev'

bash 'install_collectd_python' do
  cwd "/tmp"
  code "pip install collectd"
end

cookbook_file "/usr/share/collectd/plugins/zookeeper-collectd.py" do
  source 'zookeeper.py'
  owner 'root'
  group 'root'
  mode '0755'
  only_if { node['use_collectd'] }
  action :create  
end

unless node['chef_kafka']['include_zookeeper']
  node.set["collectd_personality"] = "zookeeper"
  include_recipe "chef_base::collectd"
end
