#!/bin/bash
# Установка non-free пакетов

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

. ./functions.sh

function restricted_install()
{
  echo 'msttcorefonts msttcorefonts/defoma note' | debconf-set-selections
  echo 'ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula boolean true' | debconf-set-selections
  echo 'ttf-mscorefonts-installer msttcorefonts/present-mscorefonts-eula note' | debconf-set-selections
  export DEBAN_FRONTEND=noninteractive
  apt-get -y install msttcorefonts

}

run_command "Установка проприетарного ПО:" restricted_install
