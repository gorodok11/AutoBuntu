#!/bin/bash
# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только из под пользователя'root' dude." 1>&2
   exit 1
fi

tput setaf 2
echo "Установка Ajenti"
tput sgr0

apt-get install sysstat python-psutil

echo '# Ajenti' | sudo tee -a /etc/apt/sources.list
echo 'deb http://repo.ajenti.org/debian main main' | sudo tee -a /etc/apt/sources.list

cd /tmp
wget http://repo.ajenti.org/debian/key -O- | sudo apt-key add -
apt-get update && apt-get -y install ajenti

# Defaults:
# port:8000
# User = admin
# Password = admin
