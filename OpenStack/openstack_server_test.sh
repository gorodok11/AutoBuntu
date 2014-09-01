#!/bin/bash

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

. ./functions.sh


# install and run kvm-ok to see if we have virt capabilities
apt-get -y install cpu-checker
if /usr/sbin/kvm-ok
then echo;
echo "#################################################################################################

Your CPU seems to support KVM extensions.  If you are installing OpenStack on a virtual machine,
you will need to add 'virt_type=qemu' to your nova.conf file in /etc/nova/ and then restart all
nova services once you've finished running through the installation.  You DO NOT need to do this
on a bare metal box.

Run './openstack_system_update.sh' to continue setup.

#################################################################################################
"
else echo;
echo "#################################################################################################

Your system isn't configured to run KVM properly.  Investigate this before continuing.

You can still modify /etc/nova/nova.conf (once nova is installed) to emulate acceleration:

[libvirt]
virt_type = qemu

#################################################################################################
"
fi
