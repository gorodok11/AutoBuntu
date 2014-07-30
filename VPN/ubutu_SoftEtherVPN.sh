#!/bin/bash
# Краткое описание скрипта

# Иипорт файла функций
. ./functions.sh

# Импорт файла параметров
. ./credentials.sh

#_______________________________________________________________________
# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root' dude." 1>&2
   exit 1
fi

apt-get -y install libreadline-dev libssl-dev libncurses5-dev zlib1g-dev
