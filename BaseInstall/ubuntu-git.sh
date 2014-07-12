#!/bin/bash
# Многие открытые проекты будут установлены из Git

. ./functions.sh

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

# Установка Git
run_command "Установка Git:" apt-get -y install git
