#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

# source the setup file
. ./setuprc

clear

# install packages
apt-get install ceilometer-api ceilometer-collector ceilometer-agent-central -y
apt-get install ceilometer-agent-notification ceilometer-alarm-evaluator ceilometer-alarm-notifier -y
apt-get install python-ceilometerclient -y

# Install MongoDB

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
apt-get update
apt-get install mongodb-org -y

# patch mongo config
sed -e "
/^bind_ip =.*$/s/^.*$/bind_ip = $managementip/
/^connection=.*$/s/^.*$/connection = mongodb://ceilometer:$password@$managementip:27017/ceilometer/
" -i /etc/mongod.conf

# restart mongo
service mongod restart

# create database
mongo --host $managementip --eval '
db = db.getSiblingDB("ceilometer");
db.addUser({user: "ceilometer",
            pwd: "$password",
            roles: [ "readWrite", "dbAdmin" ]})'
