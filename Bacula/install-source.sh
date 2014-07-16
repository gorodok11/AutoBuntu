#!/bin/bash


#wget http://sourceforge.net/projects/bacula/files/bacula/7.0.4/bacula-7.0.4.tar.gz
#tar xzvf bacula-7.0.4.tar.gz

apt-get -y install libmysql++-dev

CURR_DIR=$(cd $(dirname $0) && pwd)

echo $CURR_DIR

cd bacula-7.0.4
make distclean

./configure                     \
    --enable-smartalloc                      \
    --prefix=/var                            \
    --sbindir=/var/lib                       \
    --sysconfdir=/etc/bacula                 \
    --with-mysql                             \
    --with-openssl                           \
    --with-pid-dir=/run                      \
    --with-scriptdir=/etc/bacula/scripts     \
    --with-systemd=/usr/lib/systemd/system/  \
    --with-working-dir=/opt/bacula/working   \
    --with-logdir=/var/log                   \
    --with-dir-password="Everest8848" \
    --with-fd-password="Everest8848" \
    --with-sd-password="Everest8848" \
    --with-mon-dir-password="Everest8848" \
    --with-mon-fd-password="Everest8848" \
    --with-mon-sd-password="Everest8848" \
    --with-basename="localhost"

make
make install

cd $CURR_DIR
