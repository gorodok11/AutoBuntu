#!/bin/bash
# Файл содержит настройки пользователей сервисов

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

# Директория установочного скрипта
export ROOT_PATH=$(dirname $(readlink -f $0))
#_______________________________________________________________________
# Имя сервера
export SRVR_HOST_NAME=Ubuntu
# Имя администратора сервера
export SRVR_USER_NAME=unitlinux
#_______________________________________________________________________
# Пользователь и пароль для доступа к консоли phpPgAdmin для PostgreSQL
export PG_HT_USER=PGadmin
export PG_HT_PASS=PGPassword
#_______________________________________________________________________
# Пароль сервера mySQL для пользователя root
export MYSQL_ROOT_PASS="mySqlPass"
#_______________________________________________________________________
# Настройки Bacula
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
