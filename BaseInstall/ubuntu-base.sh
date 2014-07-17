#!/bin/bash
# Установка базового ПО.

. ./functions.sh

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

function base_install()
{
  apt-get -y install htop mc aptitude zip unzip subversion sysv-rc-conf debconf-utils
}

# Установка программ для легкой работы в консоли
run_command "Установка базового ПО:" base_install
