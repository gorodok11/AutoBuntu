#!/bin/bash

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

# single or multi?
echo;
read -p "Hit 'd' to drop the OpenStack databases.  Any other key exits. " -n 1 -r
if [[ $REPLY =~ ^[Dd]$ ]]
then

echo;

# kill them.  kill them all.
mysql -u root -p <<EOF
DROP DATABASE nova;
DROP DATABASE glance;
DROP DATABASE keystone;
DROP DATABASE quantum;
EOF

fi

echo;
