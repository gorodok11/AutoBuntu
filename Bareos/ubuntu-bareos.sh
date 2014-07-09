#!/bin/bash
# Установка системы резервного копирования Bareos

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только из под пользователем 'root'." 1>&2
   exit 1
fi

touch /etc/apt/sources.list.d/bareos.list
echo "# Bareos" /etc/apt/sources.list.d/bareos.list

URL=http://download.bareos.org/bareos/experimental/nightly/xUbuntu_14.04/
printf "deb $URL /\n" > /etc/apt/sources.list.d/bareos.list

# add package key
wget -q $URL/Release.key -O- | apt-key add -

apt-get update
apt-get install bareos bareos-database-postgresql

# Конфигурация
