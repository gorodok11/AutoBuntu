#!/bin/bash
# Установка  PHPMyAdmin

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

. ./functions.sh
. ./credentials.sh

function phpmyadmin_install()
{

  PKG_O$(dg-qry -W --showformat='${Status}\n' phpmyadmin|grep "install ok installed")
  if [ "" == "$PKG_OK" ]; then
    echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
    echo "phpmyadmin phpmyadmin/app-password-confirm password $MYSQL_ROOT_PASS" | debconf-set-selections
    echo "phpmyadmin phpmyadmin/mysql/admin-pass password $MYSQL_ROOT_PASS" | debconf-set-selections
    echo "phpmyadmin phpmyadmin/mysql/app-pass password $MYSQL_ROOT_PASS" | debconf-set-selections
    echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
    export DEBAN_FRONTEND=noninteractive
    apt-get install -y -f phpmyadmin
  fi

  service apache2 restart
}

run_command "Установка PHPMyAdmin:" phpmyadmin_install

echo "Для входа в phpMyAdmin используйте адрес http://$SRVR_HOST_NAME/phpmyadmin"
