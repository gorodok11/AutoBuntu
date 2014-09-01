#!/bin/bash

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

# source the setup file
. ./setuprc

clear

# install packages
apt-get install ceilometer-api ceilometer-collector ceilometer-agent-central -y
apt-get install ceilometer-agent-notification ceilometer-alarm-evaluator ceilometer-alarm-notifier -y
apt-get install python-ceilometerclient -y
apt-get install mongodb-server


# patch mongo config
sed -e "
/^bind_ip =.*$/s/^.*$/bind_ip = $managementip/
/^connection=.*$/s/^.*$/connection = mongodb://ceilometer:$password@$managementip:27017/ceilometer/
" -i /etc/mongodb.conf

# restart mongo
service mongodb restart

# create database
mongo --host $managementip --eval '
db = db.getSiblingDB("ceilometer");
db.addUser({user: "ceilometer",
            pwd: "$password",
            roles: [ "readWrite", "dbAdmin" ]})'
