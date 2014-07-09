#!/bin/bash
# Установка интерфейса Bareos WebUI

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только из под пользователем 'root'." 1>&2
   exit 1
fi

# Детали на:
# https://github.com/bareos/bareos-webui
