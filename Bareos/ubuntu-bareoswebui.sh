#!/bin/bash
# Установка интерфейса Bareos WebUI
# Детали на:
# https://github.com/bareos/bareos-webui

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

touch /etc/apt/sources.list.d/bareos-webui.list
echo "# Bareos WebUI" /etc/apt/sources.list.d/bareos.list

URL=http://download.bareos.org/bareos/release/latest/xUbuntu_12.04/
printf "deb $URL /\n" > /etc/apt/sources.list.d/bareos.list

# add package key
wget -q $URL/Release.key -O- | apt-key add -

apt-get update
apt-get -y install bareos bareos-database-postgresql
