## Script Flow
The scripts in this directory use a flag for determining install flow.  If the user is installing the OpenStack controller, the flow goes like this:
```
    ./openstack_networking.sh
    ./openstack_server_test.sh
    ./openstack_system_update.sh
    ./openstack_setup.sh
    ./openstack_splunk.sh
    ./openstack_mysql.sh
    ./openstack_keystone.sh
    . ./stackrc
    keystone user-list
    ./openstack_glance.sh
    glance image-list
    ./openstack_cinder.sh
    ./openstack_loop.sh
    ./openstack_nova.sh
    nova image-list
    ./openstack_horizon.sh

    nova-manage network create private --fixed_range_v4=10.0.47.0/24 --fixed_range_v6=2601:9:1380:821::/64 --num_networks=1 --bridge=br100 --bridge_interface=eth0 --network_size=255
```
If the user is installing a compute node, the flow goes like this:
```
    ./openstack_networking.sh
    ./openstack_server_test.sh
    ./openstack_system_update.sh
    ./openstack_setup.sh
    ./openstack_cinder.sh
    ./openstack_loop.sh
    ./openstack_nova_compute.sh
```
### Подключение к консоли
chmod 600 private-key.pem

ssh -i private-key.pem ubuntu@server-ip

curl -X DELETE https://sgsprunge.appspot.com/CEDSDSDSdadasd

http://192.168.1.98/phpmyadmin
https://192.168.1.98:10000/
http://192.168.1.98:8000/
http://192.168.1.98/horizon

```
nova quota-class-update --ram 102400 default

```

### Windows Server 2012 r2
```
nova get-password <instance id or name> <path to SSH private key>

gunzip -cd  windows_server_2012_r2_standard_eval_kvm_20140607.qcow2.gz | \
glance image-create --name="Windows Server 2012 R2 Standard Eval" --is-public=true --container-format=bare --disk-format=qcow2
```
The user set by Cloudbase-Init is “Admin”.
Starting with Grizzly, the password can get obtained with:
```
nova get-password
```
The “Administrator” user is available as well, but for security reasons the password must be set when connected to the console (e.g.: in Horizon), not via RDP.
