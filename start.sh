#!/bin/sh
PWD=`pwd`

export HOST_IP=$(ip -f inet -o addr show eth0|cut -d\  -f 7 | cut -d/ -f 1)
export SPARK_HOME=$PWD/spark
export ZEPPELIN_HOME=$PWD/zeppelin


$SPARK_HOME/sbin/start-master.sh
$SPARK_HOME/sbin/start-slave.sh spark://$HOST_IP:7077
$ZEPPELIN_HOME/bin/zeppelin-daemon.sh --config $ZEPPELIN_HOME/conf start

