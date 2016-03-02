#!/bin/sh

HOME=`pwd`
export SPARK_HOME=$PWD/spark
export ZEPPELIN_HOME=$PWD/zeppelin
export ZEPPELIN_PORT=8888

if [ ! -d "SPARK_HOME" ]; then
  mkdir $SPARK_HOME
fi

if [ ! -d "ZEPPELIN_HOME" ]; then
  mkdir $ZEPPELIN_HOME
fi

HOST_IP=$(ip -f inet -o addr show eth0|cut -d\  -f 7 | cut -d/ -f 1)

#Download Spark
mkdir download
cd download
wget http://d3kbcqa49mib13.cloudfront.net/spark-1.6.0-bin-hadoop2.6.tgz
cd $HOME

#Unpack spark
tar zxf download/spark-1.6.0-bin-hadoop2.6.tgz -C $SPARK_HOME --strip-components=1

#Configure park
cp $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh
echo >> $SPARK_HOME/conf/spark-env.sh
echo "export SPARK_LOCAL_IP=$HOST_IP" >> $SPARK_HOME/conf/spark-env.sh
echo "export SPARK_MASTER_IP=$HOST_IP" >> $SPARK_HOME/conf/spark-env.sh
echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> $SPARK_HOME/conf/spark-env.sh

cp $SPARK_HOME/conf/spark-defaults.conf.template $SPARK_HOME/conf/spark-defaults.conf
echo >> $SPARK_HOME/conf/spark-defaults.conf
echo "spark.cassandra.connection.host    $HOST_IP" >> $SPARK_HOME/conf/spark-defaults.conf

sed 's/log4j.rootCategory=INFO, console/log4j.rootCategory=WARN, console/' \
    $SPARK_HOME/conf/log4j.properties.template > $SPARK_HOME/conf/log4j.properties


#Download zeppelin (MASTER seems to be unstable better to get the last release)
git clone https://github.com/apache/incubator-zeppelin.git -b branch-0.5.6 $ZEPPELIN_HOME

#Patch it with update guava
cd $ZEPPELIN_HOME
patch -p1 < ../guava.patch

#build zeppelin
mvn clean package -Pspark-1.6 -Phadoop-2.6 -Pyarn -Ppyspark -DskipTests
cd $HOME

#Configure Zeppelin
cp $ZEPPELIN_HOME/conf/zeppelin-env.sh.template $ZEPPELIN_HOME/conf/zeppelin-env.sh
echo >> $ZEPPELIN_HOME/conf/zeppelin-env.sh
echo "export MASTER=spark://$HOST_IP:7077" >> $ZEPPELIN_HOME/conf/zeppelin-env.sh
echo "export SPARK_HOME=$SPARK_HOME" >> $ZEPPELIN_HOME/conf/zeppelin-env.sh 
echo "export ZEPPELIN_PORT=$ZEPPELIN_PORT" >> $ZEPPELIN_HOME/conf/zeppelin-env.sh
echo "export SPARK_SUBMIT_OPTIONS=\"--packages datastax:spark-cassandra-connector:1.6.0-M1-s_2.10\"" >> $ZEPPELIN_HOME/conf/zeppelin-env.sh
echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> $ZEPPELIN_HOME/conf/zeppelin-env.sh
echo "export ZEPPELIN_JAVA_OPTS=\"-Dspark.cassandra.connection.host=$HOST_IP\"" >> $ZEPPELIN_HOME/conf/zeppelin-env.sh

#Done run start.sh to start up the services
