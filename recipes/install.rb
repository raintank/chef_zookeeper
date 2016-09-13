#
# Cookbook Name:: chef_zookeeper
# Recipe:: install
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

# bit of a chicken and egg problem here, since we install zookeeper, then
# kafka, and until we have all the kafkas and zookeepers we can't do this very 
# well. Basically on initial deployment we'll need to run chef twice.

kafkas = if Chef::Config[:solo]
    node['chef_zookeeper']['kafkas']
  else
    search("node", node['chef_zookeeper']['kafka_search']).map { |c| c.hostname }.sort || node['chef_zookeeper']['kafkas']
  end

kafkas.each do |k|
  k =~ /(\d+)/
  kid = $1 || 1 # don't have more than one kafka server with no numbers in the
		# hostname
  node.default['zookeeper']['config']["server.#{kid}"] = "#{k}:2888:3888"
end

node['hostname'] =~ /(\d+)/
myid = $1 || "1"

directory node['zookeeper']['config']['dataDir'] do
  mode "0755"
  owner "root"
  group "root"
  action :create
end

file "#{node['zookeeper']['config']['dataDir']}/myid" do
  mode "0644"
  owner "root"
  group "root"
  content myid
  action :create
end

include_recipe "zookeeper::default"
include_recipe "zookeeper::service"
tag("zookeeper")
