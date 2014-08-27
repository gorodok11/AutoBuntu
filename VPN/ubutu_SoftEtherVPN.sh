#!/bin/bash
# Установка SoftEtherVPN

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root' dude." 1>&2
   exit 1
fi

apt-get -y install build-essential libreadline-dev libssl-dev libncurses5-dev zlib1g-dev make checkinstall

mkdir -p /opt/install
cd /opt/install
# Вместо «make install» я пишу «checkinstall», дабы менеджер пакетов apt знал о новой программулине и мог потом ее корректно удалить (подробнее здесь).
git clone https://github.com/unitlinux/SoftEtherVPN.git
cd SoftEtherVPN
./configure
make
checkinstall

vpnserver start

# Установка менеджера пакетов npm
apt-get -y install npm
