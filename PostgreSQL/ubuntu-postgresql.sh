#!/bin/bash
# Установка PostgreSQL

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root' dude." 1>&2
   exit 1
fi

. ./functions.sh
. ./credentials.sh

function postgres_install()
{
  apt-get -y install postgresql postgresql-contrib postgresql-common openssl
  sudo -u postgres psql -d postgres -c "ALTER USER postgres WITH PASSWORD '$PGSQL_ROOT_PASS';"
}

run_command "Установка PostgreSQL:" postgres_install
