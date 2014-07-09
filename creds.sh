#!/bin/bash
# Файл содержит настройки пользователей сервисов

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

# Имя сервера
export SERVER_HOST_NAME=Ubuntu
# Имя администратора сервера
export SERVER_USER_NAME=unitlinux
# Пользователь и пароль для доступа к консоли phpPgAdmin для PostgreSQL
export PG_HT_USERNAME=PGadmin
export PG_HT_PASSWORD=PGPassword
# Пароль сервера mySQL
export MYSQL_PASSWORD=mySqlPass
