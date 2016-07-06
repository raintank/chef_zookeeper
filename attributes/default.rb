alloc = (node.memory.total.to_i / 2).floor / 1024
java_opts = "-Xms#{alloc}M -Xmx#{alloc}M"
default['zookeeper']['java_opts']
