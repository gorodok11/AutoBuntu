#!/bin/bash
# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только из под пользователя'root' dude." 1>&2
   exit 1
fi

# Установка Git
sudo apt-get -y install git-core
