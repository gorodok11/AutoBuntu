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
  mkdir -p $BACULA_BACK_DIR/bacula/backup $BACULA_BACK_DIR/bacula/restore
  chown -R bacula:bacula $BACULA_BACK_DIR
  chmod -R 700 $BACULA_BACK_DIR
  chown -R bacula:bacula $BACULA_DIR
  chmod -R 755 $BACULA_DIR
}

function bacula_config()
{
  cp -f "${BACULA_DIR}/bacula-dir.conf" "${BACULA_DIR}/bacula-dir.conf.original"
  cp -f "${BACULA_DIR}/bacula-sd.conf"  "${BACULA_DIR}/bacula-sd.conf.original"
  cp -f "${BACULA_DIR}/bacula-fd.conf"  "${BACULA_DIR}/bacula-fd.conf.original"
  cp -f "${BACULA_DIR}/bconsole.conf"   "${BACULA_DIR}/bconsole.conf.original"

  #Для просмотра сообщений Job output, нужно внести измнения в bacula-dir.conf
  sed -i "s/catalog = all.*/catalog = all\, \!skipped\, \!saved/" $BACULA_DIR/bacula-dir.conf


}

function baculaweb_install()
{
  # Установка WEB клиента bacula-web
  apt-get -y install libapache2-mod-php5 php5-mysql php5-gd
  wget http://www.bacula-web.org/files/bacula-web.org/downloads/bacula-web-6.0.0.tgz
  tar -xzf bacula-web-6.0.0.tgz
  rm -rf bacula-web-6.0.0.tgz
  mv -v bacula-web-6.0.0 $BACULAWEB_DIR
  chown -Rv www-data:www-data $BACULAWEB_DIR
  chmod -Rv u=rx,g=rx,o=rx $BACULAWEB_DIR
  chmod 700 "${BACULAWEB_DIR}/application/view/cache"

  # Настройка Bacula-web
  cp -v "${BACULAWEB_DIR}/application/config/config.php.sample" "${BACULAWEB_DIR}/application/config/config.php"
  chown -v www-data:www-data "${BACULAWEB_DIR}/application/config/config.php"
}

run_command "Установка Bacula:" bacula_install
run_command "Настройка Bacula:" bacula_config
run_command "Установка Bacula-WEB:" baculaweb_install

# --> Доработать
# Настройка файлов конфигурации
