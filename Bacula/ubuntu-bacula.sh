#!/bin/bash
# Установка системы резервного копирования Bacula

. ./functions.sh
. ./credentials.sh

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

function bacula_install()
{
  apt-get -y install bacula-server bacula-client
  # Создание директорий для резервных копий
  mkdir -p $BACULA_DIR/bacula/backup $BACULA_DIR/bacula/restore
  chown -R bacula:bacula $BACULA_DIR
  chmod -R 700 $BACULA_DIR
  chown -R bacula:bacula /etc/bacula/
  chmod -R 755 /etc/bacula/
}

BACULAWEB_APP_DIR = "/var/www/bacula-web/application"

function baculaweb_install()
{
  # Установка WEB клиента bacula-web
  apt-get -y install libapache2-mod-php5 php5-mysql php5-gd
  wget http://www.bacula-web.org/files/bacula-web.org/downloads/bacula-web-6.0.0.tgz
  tar -xzf bacula-web-6.0.0.tgz
  rm -rf bacula-web-6.0.0.tgz
  mv -v bacula-web-6.0.0 /var/www/bacula-web
  chown -Rv www-data:www-data /var/www/bacula-web
  chmod -Rv u=rx,g=rx,o=rx /var/www/bacula-web
  chmod -Rv u=rx,g=rx,o=rx /var/www/bacula-web
  chmod 700 "${BACULAWEB_APP_DIR}/view/cache"

  # Настройка Bacula-web
  cp -v "${BACULAWEB_APP_DIR}/config/config.php.sample" "${BACULAWEB_APP_DIR}/config/config.php"
  chown -v www-data:www-data "${BACULAWEB_APP_DIR}/config/config.php"
}

run_command "Установка Bacula:" bacula_install
run_command "Установка Bacula-WEB:" baculaweb_install

# --> Доработать
# Настройка файлов конфигурации
