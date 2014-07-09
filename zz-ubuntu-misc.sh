#!/bin/bash
# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только из под пользователя'root' dude." 1>&2
   exit 1
fi

#Активируем репозиторий Ubuntu extras
#Перед импортом ключа убедитесь что порт 11371 не заблокирован
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3E5C1192
