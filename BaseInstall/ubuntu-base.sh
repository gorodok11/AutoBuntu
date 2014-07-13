#!/bin/bash
# Установка базового ПО.

. ./functions.sh

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

# Установка программ для легкой работы в консоли
run_command "Установка базового ПО." apt-get -y install htop mc aptitude zip unzip chkconfig subversion
