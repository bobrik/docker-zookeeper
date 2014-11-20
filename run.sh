#!/bin/sh

set -e

if [ -f "/etc/zookeeper/conf/zoo.cfg" ]; then
    echo "zookeeper config found, thank you"
else
    if [ -z "${ZK_CONFIG}" ]; then
        echo "zookeeper config not found, here are the options:"
        echo "  - bind-mount /etc/zookeeper/conf/zoo.cfg"
        echo "  - specify ZK_CONFIG env variable with config values"
        exit 1
    fi

    echo "dataDir=/var/lib/zookeeper" > "/etc/zookeeper/conf/zoo.cfg"

    for line in $(echo "${ZK_CONFIG}" | tr "," "\n"); do
        echo "$line" >> "/etc/zookeeper/conf/zoo.cfg"
    done
fi

if [ -e "/var/lib/zookeeper/myid" ]; then
    echo "zookeeper node id found, using it"
else
    if [ -z "${ZK_ID}" ]; then
        echo "zookeeper node id not found, here are your options:"
        echo "  - bind-mount /var/lib/zookeeper with myid"
        echo "  - specify ZK_ID env variable with id"
        exit 1
    fi

    echo "${ZK_ID}" > "/var/lib/zookeeper/myid"
fi

exec /usr/share/zookeeper/bin/zkServer.sh start-foreground
