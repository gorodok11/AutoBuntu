#!/bin/bash

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только из под пользователя'root' dude." 1>&2
   exit 1
fi

# Установка OpenSSH-server
sudo apt-get -y install openssh-server

# Просмотр настроек, убрав пустые строки и комментарии:
# egrep -v '^#' /etc/ssh/sshd_config | egrep -v '^$'

# Добавляем группу для пользователей ssh
#sudo addgroup --gid 450 sshlogin

#echo $(date) $SSH_CONNECTION $USER $SSH_TTY >> /var/log/sshd_connect
sudo /etc/init.d/ssh start
