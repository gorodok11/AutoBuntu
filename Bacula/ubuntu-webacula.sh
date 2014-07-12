#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

a2enmod php5
a2enmod rewrite

wget http://downloads.sourceforge.net/project/webacula/webacula/5.5.1/webacula-5.5.1.tar.gz
tar -zxvf webacula-5.5.1.tar.gz
mv webacula-5.5.1 /var/www/html/webacula


wget https://packages.zendframework.com/releases/ZendFramework-1.12.3/ZendFramework-1.12.3.tar.gz
tar -zxvf ZendFramework-1.12.3.tar.gz
mv ZendFramework-1.12.3/library/Zend/ /var/www/html/webacula/library/
cp -r ZendFramework-1.12.3/library/Zend/ /var/www/html/webacula/library/

nano /var/www/html/webacula/install/db.conf

# bacula settings
#db_name="bacula"
# for Sqlite only
#db_name_sqlite="/var/bacula/working/bacula.db"
#db_user="root"

## CHANGE_THIS
#db_pwd="12345"

# Webacula web interface settings
...
#
# CHANGE_THIS
#webacula_root_pwd="12345"
cd /var/www/html/webacula/install/MySql
 ./10_make_tables.sh
 ./20_acl_make_tables.sh
 nano /var/www/html/webacula/html/.htaccess

## SetEnv APPLICATION_ENV development
#SetEnv APPLICATION_ENV production
# Add following line
#catalog = all, !skipped, !saved

nano /etc/bacula/bacula-dir.conf

# Edit section
#Messages {
#Name = Standard
#...
#catalog = all, !skipped, !saved

service bacula-director restart

nano /etc/php5/apache2/php.ini
# Change max_execution_time = 30
# max_execution_time = 3600

nano /var/www/html/webacula/application/config.ini

# Modufy next lines
#db.adapter = PDO_MYSQL
#db.config.host = localhost
#db.config.username = root
#db.config.password = 12345
#db.config.dbname = bacula
#def.timezone = "Europe/Moscow"
#...
#bacula.sudo = ""
#bacula.bconsole = "/usr/bin/bconsole"

chown www-data: /usr/bin/bconsole
chmod u=rwx,g=rx,o= /usr/bin/bconsole
chown www-data: /etc/bacula/bconsole.conf
chmod u=rw,g=r,o= /etc/bacula/bconsole.conf
chown -R www-data:www-data /var/www/html/webacula

nano /etc/apache2/sites-available/webacula.conf

apt-get install php-pear php5 php5-dev
apt-get install libmysqlclient15-dev

nano /usr/include/php5/Zend/zend.h
#Нужно в /usr/include/php5/Zend/zend.h в район 320 строки добавить

#define refcount refcount__gc
#define is_ref is_ref__gc

# --> Доработать

nano /usr/include/php5/Zend/zend_API.h
#А в /usr/include/php5/Zend/zend_API.h в район 50 строки
#define object_pp object_ptr

#Paste these lines:
#Alias /webacula /var/www/html/webacula/html
#<Directory /var/www/html/webacula/html>
#Options FollowSymLinks
#AllowOverride All
#Order deny,allow
#Allow from All
#</Directory>

service apache2 restart

# Login to web console at http://yourIP/webacula/
