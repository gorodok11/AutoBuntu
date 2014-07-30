#!/bin/bash
# Настройка сетевого экрана.

. ./functions.sh

# Удаление всех правил
function reset_iptables ()
{
  iptables -F
  iptables -P OUTPUT ACCEPT
  iptables -P INPUT ACCEPT
  iptables -P FORWARD ACCEPT

  service iptables save
  service iptables restart
}

function set_iptables ()
{
  # Input
  iptables -A INPUT -p tcp --dport 22 -j ACCEPT # SSH
  iptables -A INPUT -p udp --dport 22 -j ACCEPT # SSH
  iptables -A INPUT -p tcp --dport 5432 -j ACCEPT # PostgreSQL
  iptables -A INPUT -p udp --dport 5432 -j ACCEPT # PostgreSQL
  iptables -A INPUT -j DROP # Default rule

  # Output
  iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT # SSH
  iptables -A OUTPUT -p udp --dport 22 -j ACCEPT # SSH
  iptables -A OUTPUT -p udp --dport 67:69 -j ACCEPT # DHCP
  iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT # HTTP
  iptables -A OUTPUT -p tcp --dport 5432 -j ACCEPT # PostgreSQL
  iptables -A OUTPUT -p udp --dport 5432 -j ACCEPT # PostgreSQL
  iptables -A OUTPUT -p tcp --dport 10000 -j ACCEPT # Webmin

  iptables -A OUTPUT -j DROP # Default rule


  service iptables save
  service iptables restart
}
