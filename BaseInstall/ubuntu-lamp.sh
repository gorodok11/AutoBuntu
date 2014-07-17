#!/bin/bash
# Установка LAMP server

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

. ./functions.sh
. ./credentials.sh

function lamp_install()
{
  # Apache
  apt-get -y install apache2 libapache2-mod-php5 apache2-utils
  # MySQL
  debconf-set-selections <<< 'mysql-server mysql-server/root_password password $MYSQL_ROOT_PASS'
  debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASS'
  apt-get install -y mysql-server
  apt-get install -y mysql-client mysql-common
  # PHP 5
  apt-get -y install python-software-properties
  apt-get -y install php5 php5-gd php5-mysql php5-curl php5-cli php5-cgi php5-dev php5-fpm
  apt-get -y install php5-memcache memcached
  # Настройка файрвола
  ufw allow 80
  ufw allow 443 

  service apache2 restart

}

function phpmyadmin_install()
{
  # Установка phpMyAdminPHP 5
  debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
  debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password $MYSQL_ROOT_PASS'
  debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password $MYSQL_ROOT_PASS'
  debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password $MYSQL_ROOT_PASS'
  debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'
  apt-get -y install phpmyadmin

  service apache2 restart
}
mySqlPass
run_command "Установка LAMP:" lamp_install
run_command "Установка PHPMyAdmin:" phpmyadmin_install

echo "Для входа в phpMyAdmin используйте адрес http://$SRVR_HOST_NAME/phpmyadmin"
