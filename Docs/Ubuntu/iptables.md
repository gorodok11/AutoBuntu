### Как сохранить настройки iptables?

iptables-save > iptables.conf
iptables-restore

### Как сделать "проброс" (DNAT) портов в iptables?

iptables --table nat -I PREROUTING   -p tcp --dst $WAN_IP --dport 3000 -j DNAT --to $LAN_IP:2000

iptables --table nat -I PREROUTING   -p tcp --dst $WAN_IP --dport 3000 -j DNAT --to $LAN_IP:2000

### Проброс портов для почтового сервера

iptables -t nat -A PREROUTING -p tcp -i em1 --dport 2225  -j DNAT --to 10.0.47.2:22
iptables -t nat -A PREROUTING -p tcp -i em1 --dport 80    -j DNAT --to 10.0.47.2:80
iptables -t nat -A PREROUTING -p tcp -i em1 --dport 110   -j DNAT --to 10.0.47.2:110
iptables -t nat -A PREROUTING -p tcp -i em1 --dport 143   -j DNAT --to 10.0.47.2:143
iptables -t nat -A PREROUTING -p tcp -i em1 --dport 443   -j DNAT --to 10.0.47.2:443
iptables -t nat -A PREROUTING -p tcp -i em1 --dport 587   -j DNAT --to 10.0.47.2:587
iptables -t nat -A PREROUTING -p tcp -i em1 --dport 993   -j DNAT --to 10.0.47.2:993
iptables -t nat -A PREROUTING -p tcp -i em1 --dport 995   -j DNAT --to 10.0.47.2:995


iptables --table nat -I PREROUTING   -p tcp --dst 78.47.231.20 --dport 2225 -j DNAT --to 10.0.47.3:22

iptables --table nat -I PREROUTING   -p tcp --dst 78.47.231.20 --dport 2224 -j DNAT --to 10.0.47.2:22
iptables --table nat -I PREROUTING   -p tcp --dst 78.47.231.20 --dport 80   -j DNAT --to 10.0.47.2:80
iptables --table nat -I PREROUTING   -p tcp --dst 78.47.231.20 --dport 110  -j DNAT --to 10.0.47.2:110
iptables --table nat -I PREROUTING   -p tcp --dst 78.47.231.20 --dport 143  -j DNAT --to 10.0.47.2:143
iptables --table nat -I PREROUTING   -p tcp --dst 78.47.231.20 --dport 443  -j DNAT --to 10.0.47.2:443
iptables --table nat -I PREROUTING   -p tcp --dst 78.47.231.20 --dport 587  -j DNAT --to 10.0.47.2:587
iptables --table nat -I PREROUTING   -p tcp --dst 78.47.231.20 --dport 993  -j DNAT --to 10.0.47.2:993
iptables --table nat -I PREROUTING   -p tcp --dst 78.47.231.20 --dport 995  -j DNAT --to 10.0.47.2:995



22/tcp  open  ssh
25/tcp  open  smtp
80/tcp  open  http
110/tcp open  pop3
143/tcp open  imap
443/tcp open  https
587/tcp open  submission
993/tcp open  imaps
995/tcp open  pop3s
