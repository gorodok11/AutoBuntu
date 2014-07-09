#!/bin/bash
# Краткое описание скрипта
#_______________________________________________________________________
# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root' dude." 1>&2
   exit 1
fi

apt-get -y install postgresql postgresql-contrib

read -p "Введите пароль пользователя 'postgres' для доступа к консоли: " PGPassword
sudo -u postgres psql -d postgres -c "ALTER USER postgres WITH PASSWORD '$PGPassword';"
