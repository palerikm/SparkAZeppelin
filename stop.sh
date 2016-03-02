#!/bin/sh
PWD=`pwd`

export SPARK_HOME=$PWD/spark
export ZEPPELIN_HOME=$PWD/zeppelin

$SPARK_HOME/sbin/stop-all.sh
$ZEPPELIN_HOME/bin/zeppelin-daemon.sh --config $ZEPPELIN_HOME/conf stop

