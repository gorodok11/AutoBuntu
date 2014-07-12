#!/bin/bash
# Обновление операционной системы

. ./functions.sh

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

print_status "Обновление операционной системы..."

apt-get update > /dev/null 2>&1
apt-get -y upgrade > /dev/null 2>&1
if [ $? -eq 0 ]; then
  print_good "Система полностью обновлена."
else
  print_error "Сбой при обновлении системы."
fi
