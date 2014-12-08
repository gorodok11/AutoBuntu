### Как сохранить настройки iptables?

iptables-save > iptables.conf
iptables-restore

### Как сделать "проброс" (DNAT) портов в iptables?

iptables --table nat -I PREROUTING   -p tcp --dst $WAN_IP --dport 3000 -j DNAT --to $LAN_IP:2000
