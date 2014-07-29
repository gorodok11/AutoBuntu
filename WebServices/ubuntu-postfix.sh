#!/bin/bash
# Установка почтового сервиса Postfix

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

. ./functions.sh
. ./credentials.sh

function postfix-install()
{

# --> Доработать!

  echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
  echo postfix postfix/mailname string $(hostname -f) | debconf-set-selections
# postfix postfix/mailname    string  /etc/mailname

  export DEBAN_FRONTEND=noninteractive
  apt-get -y install postfix

}

run_command "Установка Postfix:" postfix-install
