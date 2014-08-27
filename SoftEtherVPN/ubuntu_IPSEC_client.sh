#!/bin/bash
# Установка клиента L2TP VPN

# Иипорт файла функций
. ./functions.sh

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

SERVICE_PORT=${SERVICE_PORT:-"1701"}
KEY_SIZE=${KEY_SIZE:-"1024"}
USER_ID=${USER_ID:-"ziozzang"}
E_MAIL=${E_MAIL:-"ziozzang@gmail.com"}
USER_PW=${USER_PW:-"loginme"}


LOCAL_IP=`ifconfig eth0 | grep -m 1 'inet addr:' | cut -d: -f2 | awk '{print $1}'`
DEFAULT_GW=`route -n | grep "^0.0.0.0"  | awk '{print $2}'`

IPF=`cat /etc/sysctl.conf  | grep "^#*net.ipv4.ip_forward" | wc -l`
if [[ "$IPF" -eq "0" ]]; then
  echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
else

sed -i -e '/^#*net.ipv4.ip_forward/ c\net.ipv4.ip_forward=1' /etc/sysctl.conf

fi

apt-get --no-install-recommends -q -y --force-yes install xl2tpd bcrelay ppp ipsec-tools tdb-tools curl
cat <<EOF | debconf-set-selections
openswan openswan/install_x509_certificate boolean false
openswan openswan/restart select true
openswan openswan/runlevel_changes note
openswan openswan/install_x509_certificate seen true
EOF

export DEBIAN_FRONTEND=noninteractive
apt-get -y --force-yes install openswan

cp -fR /etc/ipsec.conf /etc/ipsec.conf.back

cat << 'EOT' > /etc/ipsec.conf
config setup
  virtual_private=%v4:10.0.0.0/8,%v4:192.168.30.0/16,%v4:172.16.0.0/12
  nat_traversal=yes
  protostack=netkey
  oe=off
  # Replace eth0 with your network interface if different; e.g. wlan0
  plutoopts="--interface=eth0"
  conn L2TP-PSK
  authby=secret
  pfs=no
  auto=add
  keyingtries=3
  dpddelay=30
  dpdtimeout=120
  dpdaction=clear
  rekey=yes
  ikelifetime=8h
  keylife=1h
  type=transport

  # Replace IP address with your local IP
  left=192.168.0.8
  leftnexthop=%defaultroute
  leftprotoport=17/1701
  # Replace IP address with your VPN server's IP
  right=31.7.62.2
  rightprotoport=17/1701

EOT
