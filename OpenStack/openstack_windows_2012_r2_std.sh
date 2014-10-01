gunzip windows_server_2012_r2_standard_eval_kvm_20140607.qcow2.gz

glance image-create --name "Windows Server 2012 R2 Standard Eval" --container-format bare --disk-format qcow2 --is-public true < windows_server_2012_r2_standard_eval_kvm_20140607.qcow2

# Enable IPv6 / IPv4 packet forwarding
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sed -i 's/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/' /etc/sysctl.conf
sysctl -p


# You might want to cleanup your expired tokens, otherwise, your database will increase in size indefinitely. So, do this:
(crontab -l 2>&1 | grep -q token_flush) || echo '@hourly /usr/bin/keystone-manage token_flush >/var/log/keystone/keystone-tokenflush.log 2>&1' >> /var/spool/cron/crontabs/root
