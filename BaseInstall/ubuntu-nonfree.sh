#!/bin/bash
# Установка non-free пакетов

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только из под пользователя'root'." 1>&2
   exit 1
fi

apt-get -y install msttcorefonts
