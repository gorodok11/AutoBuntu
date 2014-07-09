#!/bin/bash

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только из под пользователя'root' dude." 1>&2
   exit 1
fi

tput setaf 2
echo "Установка LAMP server"
tput sgr0
tasksel install lamp-server
# Установка phpMyAdmin
apt-get -y install phpmyadmin
# Для входа в phpMyAdmin используйте адрес http://server_IP/phpmyadmin
