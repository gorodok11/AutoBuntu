#!/bin/bash
# Среда разработки

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

. ./functions.sh
. ./credentials.sh

# Установка программ для легкой работы в консоли
run_command "Установка среды разработчика:" apt-get -y install build-essential
