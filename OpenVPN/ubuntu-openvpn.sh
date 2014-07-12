#!/bin/bash
# Установка OpenVPN

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root' dude." 1>&2
   exit 1
fi

apt-get -y install openvpn

cp -R /usr/share/doc/openvpn/examples/easy-rsa/ /etc/openvpn
cd /etc/openvpn/easy-rsa/2.0
ln -s openssl-1.0.0.cnf openssl.cnf
source vars
./clean-all

# Создаем пару корневой сертификат ca.crt и ключ ca.key
./build-ca

# Создаем пару сертификат сервера server.crt и ключ server.key
./build-key-server server

# Создаем пару сертификат клиента client1.crt и ключ client1.key
./build-key client1

# Ключи Диффи Хелмана
./build-dh
cd keys
mkdir /etc/openvpn/.keys && /etc/openvpn/.ccd
cp ca.crt ca.key dh1024.pem server.crt server.key /etc/openvpn/keys
cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz /etc/openvpn/
cd /etc/openvpn
gunzip -d /etc/openvpn/server.conf.gz
# nano /etc/sysctl.conf
#Находим строку и снимаем с нее комментарий:
# Enable packet forwarding
# net.ipv4.ip_forward=1

# --> Доработать
# http://habrahabr.ru/post/227767/
