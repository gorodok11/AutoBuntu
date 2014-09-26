#!/bin/bash
# Файл содержит настройки пользователей сервисов

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

# Директория установочного скрипта
export ROOT_PATH=$(dirname $(readlink -f $0))
export TOP_DIR=$(cd $(dirname "$0") && pwd)

#_______________________________________________________________________
# Имя сервера
export SRVR_HOST_NAME=Ubuntu
# Имя администратора сервера
export SRVR_USER_NAME=unitlinux
#_______________________________________________________________________
# Пароль сервера mySQL для пользователя root
export MYSQL_ROOT_PASS="mySqlPass"
#_______________________________________________________________________
# Пароль сервера PostgreSQL для пользователя postgres
export PGSQL_ROOT_PASS="PostgrePass"
export POSTGRE_HBA_CONF="/etc/postgresql/9.3/main/pg_hba.conf"
export PGSQL_DATA_DIR="/etc/postgresql/9.3/main"
#_______________________________________________________________________
# Пользователь и пароль для доступа к консоли phpPgAdmin для PostgreSQL
export PG_HT_USER="PGadmin"
export PG_HT_PASS="PGPassword"

#_______________________________________________________________________
# Настройки Bacula
export BACULA_VERSION=7.0.5
export BACULA_SQL_USER=bacula
export BACULA_SQL_PASS="baculaPass"
# Папка Bacula
export BACULA_DIR="/etc/bacula"
# Папка для хранения резервных копий
export BACULA_BACK_DIR="/MyBackup"
# Пароль доступа к базе данных
export BACULA_PASS=baculaPass
# Папка для Bacula-web
export BACULAWEB_DIR="/var/www/bacula-web"
# Папка для Webacula
export WEBACULA_DIR="/var/www/webacula"
# Пароль для входа в WEB интерфейс Webacula
export WEBACULA_PASS="webacula"
#_______________________________________________________________________
