#!/bin/bash
# Установка системы резервного копирования Bacula

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

apt-get -y install bacula-server bacula-client

# Create Backup and Restore Directories
mkdir -p /mybackup/bacula/backup /mybackup/bacula/restore
chown -R bacula:bacula /mybackup/
chmod -R 777 /mybackup/
chown -R bacula:bacula /etc/bacula/
chmod -R 744 /etc/bacula/

# --> Доработать
# Настройка файлов конфигурации

# Install WEB client bacula-web
apt-get install libapache2-mod-php5 php5-mysql php5-gd -y
cd /var/www/html
wget http://www.bacula-web.org/files/bacula-web.org/downloads/bacula-web-6.0.0.tgz
tar -xzf bacula-web-6.0.0.tgz -C /var/www/html
rm -rf bacula-web-6.0.0.tgz
mv -v /var/www/html/bacula-web-6.0.0 /var/www/html/bacula-web
chown -Rv www-data: /var/www/html/bacula-web
chmod -Rv u=rx,g=rx,o=rx /var/www/html/bacula-web
chmod -Rv u=rx,g=rx,o=rx /var/www/html/bacula-web
chmod 777 /var/www/html/bacula-web/application/view/cache

# Configuration
cd /var/www/html/bacula-web/application/config
cp -v config.php.sample config.php
chown -v www-data: config.php
