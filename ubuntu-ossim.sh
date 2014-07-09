#!/bin/bash
# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только из под пользователя'root' dude." 1>&2
   exit 1
fi

sudo apt-get -y install glib2.0 libxml2 glib-networking rrdtool php5 libgda-5.0
sudo apt-get -y install phpgacl
