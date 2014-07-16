#!/bin/bash
# Установка LAMP server

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

. ./functions.sh
. ./credentials.sh

tasksel install lamp-server

# Установка phpMyAdmin
apt-get -y install phpmyadmin apache2-utils

ufw allow 80 > /dev/null 2>&1
ufw allow 443 > /dev/null 2>&1

echo "Для входа в phpMyAdmin используйте адрес http://$SRVR_HOST_NAME/phpmyadmin"
