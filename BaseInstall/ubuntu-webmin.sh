#!/bin/bash
# Webmin — это программный комплекс, позволяющий администрировать операционную
# систему через веб-интерфейс, в большинстве случаев, позволяя обойтись без
# использования командной строки и запоминания системных команд и их параметров.

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только из под пользователем 'root'." 1>&2
   exit 1
fi

touch /etc/apt/sources.list.d/webmin.list
echo "# Webmin" /etc/apt/sources.list.d/webmin.list
echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list.d/webmin.list
echo "deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib" >> /etc/apt/sources.list.d/webmin.list

wget http://www.webmin.com/jcameron-key.asc -O- | apt-key add -
apt-get update

apt-get install webmin -y

# Сделаем порт 10000 доступным для входа по сети
ufw allow 10000
