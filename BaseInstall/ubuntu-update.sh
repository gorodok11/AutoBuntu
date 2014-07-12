#!/bin/bash
# Обновление операционной системы

. ./functions.sh

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

run_command "Обновление списка пакетов:" apt-get update
run_command "Обновление системы:" apt-get -y upgrade
