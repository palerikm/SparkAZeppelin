# SparkAZeppelin

## Summary
Zeppelin is in early stages and can be a bit painfull to install, especially with the cassandra database drivers. Making sure all the versions of the various components are compatible is a big thing. After poking around and looking at various howtos the solution was not so bad in the end. Thanks to the Zeppelin team for spending time on a very promising project.

## Install and Setup
This has been tested on Ubuntu 14.04.

### Prerequisites

* Java
* Node and libfontconfig
* Maven
* Cassandra

#### Installing Java
```sh
sudo apt-get install software-properties-common python-software-properties

#Add repo and install Oracle JAVA
sudo apt-add-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer
```
#### Installing npm and libfontconfig
```sh
sudo apt-get install npm
sudo apt-get install libfontconfig
```
#### Installing Maven
```sh
# install maven
wget http://www.eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
sudo tar -zxf apache-maven-3.3.9-bin.tar.gz -C /usr/local/
sudo ln -s /usr/local/apache-maven-3.3.9/bin/mvn /usr/local/bin/mvn
```

#### Installing Cassandra
```sh
##Installing Cassandra

echo "deb http://debian.datastax.com/datastax-ddc 3.3 main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
deb http://debian.datastax.com/datastax-ddc 3.version_number main

curl -L https://debian.datastax.com/debian/repo_key | sudo apt-key add -

sudo apt-get update
sudo apt-get install datastax-ddc
```

Stop and clear data so you can reconfigure the cluster
```sh
sudo service cassandra stop
sudo rm -rf /var/lib/cassandra/data/system/*
```
Configure cassandra
Edit /etc/cassandra/cassandra.yaml
Set listening and rpc interface to ip of your box
TODO: use encryption
```sh
sudo service cassandra start
```

### Spark and Zeppelin

#### Install
Run the following script to install.

```sh
./install.sh
```
This script will do the following:
 * download the Spark 1.6.0 with hadopp2.6
 * unpack it into a directory called spark (SPARK_HOME)
 * configure spark by updating spark/config/spark-enc.sh and other files
 * download the zepplein 5.6 branch from github
 * patch it to use updated guava version
 * build zeppelin
 * configure zeppelin
   - Various IP addresses
   - set SPARK_SUBMIT_OPTIONS to use the right cassandra connector (Build for scala 2.10)

Make sure to update the CASSANDRA_HOST variable in the script if your database is running on a different machine

#### Starting and stopping
Run the following script to start spark and zeppelin.

```sh
./start.sh
```

This script will:
* start up a spark master instance at [your_ip]:8080
* start up a spark slave and connect it to the running master.
* start up zeppelin at [your_ip]:8888

Run
```sh
./stop.sh
```
To stop spark and zeppelin.
