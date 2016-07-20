alloc = (node.memory.total.to_i / 2).floor / 1024
java_opts = "-Xms#{alloc}M -Xmx#{alloc}M"
default['zookeeper']['java_opts'] = java_opts
default[:chef_zookeeper][:kafka_search] = "chef_environment:#{node.chef_environment} AND tags:kafka"
default[:chef_zookeeper][:kafkas] = []
