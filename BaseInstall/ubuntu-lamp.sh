#!/bin/bash
# Установка LAMP server

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

tasksel -y install lamp-server

# Установка phpMyAdmin
apt-get -y install phpmyadmin apache2-utils > /dev/null 2>&1

# Для входа в phpMyAdmin используйте адрес http://server_IP/phpmyadmin

ufw allow 80 > /dev/null 2>&1
ufw allow 443 > /dev/null 2>&1
