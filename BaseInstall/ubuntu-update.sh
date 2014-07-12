#!/bin/bash
# Обновление операционной системы

. ./functions.sh

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

run_command "Обновление операционной системы..." apt-get update && apt-get -y upgrade
