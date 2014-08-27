#!/bin/bash
# Установка Zabbix

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root' dude." 1>&2
   exit 1
fi

wget http://repo.zabbix.com/zabbix/2.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_2.2-1+trusty_all.deb
dpkg -i zabbix-release_2.2-1+trusty_all.deb
apt-get update

apt-get -y install zabbix-server-mysql zabbix-frontend-php

# --> Доработать
# Zabbix frontend is available at http://zabbix-frontend-hostname/zabbix in the browser.
# Default username/password is Admin/zabbix

# Editing PHP configuration for Zabbix frontend

# Apache configuration file for Zabbix frontend is located in /etc/apache2/conf.d/zabbix. Some PHP settings are already configured.

# php_value max_execution_time 300
# php_value memory_limit 128M
# php_value post_max_size 16M
# php_value upload_max_filesize 2M
# php_value max_input_time 300
# php_value date.timezone Europe/Moscow
# It's necessary to uncomment the “date.timezone” setting and set the correct timezone for you.
# After changing the configuration file restart the apache web server.

service apache2 restart
