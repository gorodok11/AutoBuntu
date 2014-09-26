#!/bin/bash

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

. ./functions.sh

function network_install()
{
  # bridge stuff
  apt-get -y install vlan qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils

  # install time server
  apt-get -y install ntp
  service ntp restart

  # modify timeserver configuration
sed -e "
/^server ntp.ubuntu.com/i server 127.127.1.0
/^server ntp.ubuntu.com/i fudge 127.127.1.0 stratum 10
/^server ntp.ubuntu.com/s/^.*$/server ntp.ubutu.com iburst/;
" -i /etc/ntp.conf

# turn on forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl net.ipv4.ip_forward=1

}

run_command "Установка сетевого моста и сервера времени:" network_install

echo;
echo "##############################################################################################################

Редактируйте файл /etc/network/interfaces как в следующем примере:

# loopback
auto lo
iface lo inet loopback
iface lo inet6 loopback

# primary interface
auto eth0
iface eth0 inet static
  address 10.0.1.100
  netmask 255.255.255.0
  gateway 10.0.1.1
  dns-nameservers 8.8.8.8

# ipv6 configuration
iface eth0 inet6 auto

Тепери редактируйте файл /etc/hosts как в следующем примере:

127.0.0.1	localhost
10.0.1.100	VSP # HOST SERVER
10.0.1.101	DBS # DATABASE SERVER
10.0.1.102	TS  # TERMINAL SERVER

Убедитесь что все IP адреса машин из кластера записаны в /etc/hosts .

После этого перезагружайте сеть командой 'sudo ifdown --exclude=lo -a && sudo ifup --exclude=lo -a'.

To start the virtualization test, run './openstack_server_test.sh'

###############################################################################################################"

ifdown --exclude=lo -a && ifup --exclude=lo -a
