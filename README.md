# Dockerized zookeeper customizeable with env varaibles

It appeared that other zookeeper images cannot make a cluster
or change configuration without bind-mounting config file.

This one can be configured with bind-mounting and
with env variables. This image can even form zookeeper cluster
from env variables only.

## Usage

### Env variables

#### Single-node super-simple setup:

```
docker run -d -p 2181:2181 -e ZK_CONFIG=clientPort=2181 -e ZK_ID=1 bobrik/zookeeper
```

#### Clustering

Same as single node, but you should add more configuration to `ZK_CONFIG`,
some production-ready string could look like this for 3-node cluster:

```
tickTime=2000,initLimit=10,syncLimit=5,maxClientCnxns=8000,forceSync=no,autopurge.snapRetainCount=5,autopurge.purgeInterval=2,clientPort=2181,server.1=zk1.local:2888:3888,server.2=zk2.local:2888:3888,server.3=zk3:2888:3888
```

You should also expose ports `2888` and `3888`
in addition to `2181` to make it work.

Each node should be launched with correct `ZK_ID`.

#### Bind-mounting

If you already have configuration file, you should mount it
to container's dir `/etc/zookeeper/conf`.

It is a great idea to persist data on host filesystem.
To do so, please bind-mount `/var/lib/zookeeper` for data
and `/var/log/zookeeper` for logs.
