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
  PKG_OK=$(dpkg-query -W --showformat='${Status}\n' mysql-server|grep "install ok installed")
  if [ "" == "$PKG_OK" ]; then
    echo "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASS" | debconf-set-selections
    echo "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASS" | debconf-set-selections
    export DEBIAN_FRONTEND=noninteractive
    apt-get -y -f install mysql-server
  fi

  apt-get -y install mysql-client mysql-common
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

  PKG_O$(dg-qry -W --showformat='${Status}\n' phpmyadmin|grep "install ok installed")
  if [ "" == "$PKG_OK" ]; then
    echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
    echo "phpmyadmin phpmyadmin/app-password-confirm password $MYSQL_ROOT_PASS" | debconf-set-selections
    echo "phpmyadmin phpmyadmin/mysql/admin-pass password $MYSQL_ROOT_PASS" | debconf-set-selections
    echo "phpmyadmin phpmyadmin/mysql/app-pass password $MYSQL_ROOT_PASS" | debconf-set-selections
    echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
    export DEBAN_FRNTEND=noninteractive
    apt-get install - -f phpmyadmin
  fi

  service apache2 restart
}

run_command "Установка LAMP:" lamp_install
run_command "Установка PHPMyAdmin:" phpmyadmin_install

echo "Для входа в phpMyAdmin используйте адрес http://$SRVR_HOST_NAME/phpmyadmin"
