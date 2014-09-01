#!/bin/bash

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

# restart nova
service nova-api restart
service nova-cert restart
service nova-api restart
service nova-conductor restart
service nova-consoleauth restart
service nova-network restart
service nova-compute restart
service nova-novncproxy restart
service nova-scheduler restart
