#!/bin/bash

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

. ./functions.sh


#Ставим программу monit, которая будет отслеживать запущена ли 1с и при необходимости запускать:

apt-get -y install monit

# Далее бэкапим и правим конфиг:
cp /etc/monit/monitrc /etc/monit/monitrc.bak
echo "" > /etc/monit/monitrc

cat >> /etc/monit/monitrc <<EOF
set logfile syslog facility log_daemon
set idfile /var/lib/monit/id
set statefile /var/lib/monit/state

set eventqueue
     basedir /var/lib/monit/events
     slots 100

###############################################################################
## Check 1C
###############################################################################

check process ragent with pidfile /var/run/srv1cv83.pid
    start program = "/etc/init.d/srv1cv83 start"
    stop program  = "/etc/init.d/srv1cv83 stop"
###############################################################################
## Includes
###############################################################################
include /etc/monit/conf.d/*
EOF


/etc/init.d/monit restart

Теперь в случае вылета сервера 1с - он будет автоматически перезапущен.
