#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

. ./functions.sh
. ./credentials.sh

function webacula_install()
{
  apt-get -y install apache2 php5 libapache2-mod-php5 php5-mysql php5-gd

  a2enmod php5
  a2enmod rewrite
  sed -i "s/^\;date.timezone\ \?=$/date.timezone = Europe\/Moscow/g" /etc/php5/apache2/php.ini

  git clone https://github.com/tim4dev/webacula.git $WEBACULA_DIR
 # Доустанавливаем Zend и создаем симлинк на него в папке library:
  apt-get -y install zend-framework
  ln -s /usr/share/php/libzend-framework-php/Zend "${WEBACULA_DIR}/library/"
 #Добавляем пользователя bacula в группу веб-сервера
  usermod -aG bacula www-data
  chown -R www-data:www-data $WEBACULA_DIR

  # Устанавливаем необходимые права доступа к bconsole из Apache.
  chown root:bacula /usr/sbin/bconsole
  chmod u=rwx,g=rx,o= /usr/sbin/bconsole
  chown root:bacula /etc/bacula/bconsole.conf
  chmod u=rw,g=r,o= /etc/bacula/bconsole.conf

  echo "www-data ALL=NOPASSWD: /usr/sbin/bconsole" >> /etc/sudoers
  # Правим config.ini
  sed -i "s/^def.timezone.*/def.timezone = \"Europe\/Moscow\"/" $WEBACULA_DIR/application/config.ini
  sed -i "s/^db.config.username.*/db.config.username = $BACULA_SQL_USER/" $WEBACULA_DIR/application/config.ini
  sed -i "s/^db.config.password.*/ddb.config.password = $BACULA_SQL_PASS/" $WEBACULA_DIR/application/config.ini
  sed -i "s/^\; locale.*/locale = \"ru\"/" $WEBACULA_DIR/application/config.ini
  sed -i "s/^bacula.bconsole =.*/bacula.bconsole = \"\/usr\/sbin\/bconsole\"/" $WEBACULA_DIR/application/config.ini
  # Правим db.conf - Пароль для входа в вебинтерфейс
  sed -i "s/^webacula_root_pwd.*/webacula_root_pwd=\"$WEBACULA_PASS\"/" $WEBACULA_DIR/install/db.conf
  sed -i "s/^db_pwd.*/db_pwd=\"$MYSQL_ROOT_PASS\"/" $WEBACULA_DIR/install/db.conf

  # Cоздаем таблицы Webacula, пользователей и роли
  .$WEBACULA_DIR/MySql/10_make_tables.sh
  .$WEBACULA_DIR/MySql/20_acl_make_tables.sh

  sed -i "s/^max_execution_time.*/max_execution_time = 3600/" /etc/php5/apache2/php.ini

  cp $WEBACULA_DIR/install/apache/webacula.conf /etc/apache2/sites-available/webacula.conf
  sed -i "s:/usr/share/webacula:$WEBACULA_DIR:g" /etc/apache2/sites-available/webacula.conf
  sed -i "s/^SetEnv APPLICATION_ENV development.*/# SetEnv APPLICATION_ENV development/" $WEBACULA_DIR/html/.htaccess
  sed -i "s/^# SetEnv APPLICATION_ENV production.*/SetEnv APPLICATION_ENV production/" $WEBACULA_DIR/html/.htaccess

  echo '' >> $WEBACULA_DIR/html/.htaccess
  echo 'catalog = all, !skipped, !saved' >> $WEBACULA_DIR/html/.htaccess

  sed -i "s/^define('BACULA_VERSION', 12);.*/define('BACULA_VERSION', 14);/g"  $WEBACULA_DIR/html/index.php

  a2enmod rewrite
  a2ensite webacula
  service apache2 restart
  service bacula-director restart
}

run_command "Установка Webacula:" webacula_install
