#!/bin/bash

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

rm -rf images/*
rm -f setuprc
rm -f stackrc
rm -f ec2rc
rm -f .*.swp
rm -f stackmonkey*
