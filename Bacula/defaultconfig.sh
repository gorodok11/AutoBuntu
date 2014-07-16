#!/bin/sh
#
# This is a default configuration file for Bacula that
# sets reasonable defaults, and assumes that you do not
# have MySQL running.  It will "install" Bacula into
# bin and etc in the current directory.
#




CFLAGS="-g -Wall" \
  ./configure \
    --sbindir=$HOME/bacula/bin \
    --sysconfdir=$HOME/bacula/bin \
    --with-pid-dir=$HOME/bacula/bin/working \
    --with-subsys-dir=$HOME/bacula/bin/working \
    --enable-smartalloc \
    --enable-static-tools \
    --with-mysql=$HOME/mysql \
    --with-working-dir=$HOME/bacula/bin/working \
    --with-dump-email=root@localhost \
    --with-job-email=root@localhost \
    --with-smtp-host=localhost

exit 0


#!/bin/sh

$ ./configure/bacula'
'-sbndr=op/bcua/bin'
'--sysonfir=optbacla/onf'
'--enable-sartaloc'
'-enabe-tray-moitor'
'--with-mysql'
'--withworkng-di=/optbacul/workig'
'--with-pid-dir=/opt/bacula/woring'
'-with-subsys-dir=/opt/bacula/working''--enable-conio'



find . -name bacula
./var/lib/bacula
./var/lib/mysql/bacula
./var/log/bacula
./run/bacula
./etc/bacula
./usr/lib/bacula
Configuration on Thu Mar 20 13:38:43 CST 2014:



./var/lib/bacula
./var/share/doc/bacula
./opt/bacula
./etc/bacula
./etc/bacula/scripts/bacula


   Install binaries:        /var/lib
   Install libraries:       /var/lib
   Install config files:    /etc/bacula
   Scripts directory:       /etc/bacula/scripts
   Archive directory:       /tmp
   Working directory:       /opt/bacula/working
   PID directory:           /run
   Subsys directory:        /var/run/subsys
   Man directory:           ${datarootdir}/man
   Data directory:          /var/share
   Plugin directory:        /var/lib








./configure                              \
    --enable-bat                             \
    --enable-smartalloc                      \
    --prefix=/var                            \
    --sbindir=/var/lib                       \
    --sysconfdir=/etc/bacula                 \
    --with-mysql=/var/lib/mysql                             \
    --with-openssl                           \
    --with-pid-dir=/run                      \
    --with-scriptdir=/etc/bacula/scripts     \
    --with-systemd=/usr/lib/systemd/system/  \
    --with-working-dir=/opt/bacula/working   \
    --with-logdir=/var/log                   \
    --with-x                                 \
    --with-dir-password="XXX_REPLACE_WITH_DIRECTOR_PASSWORD_XXX" \
    --with-fd-password="XXX_REPLACE_WITH_CLIENT_PASSWORD_XXX" \
    --with-sd-password="XXX_REPLACE_WITH_STORAGE_PASSWORD_XXX" \
    --with-mon-dir-password="XXX_REPLACE_WITH_DIRECTOR_MONITOR_PASSWORD_XXX" \
    --with-mon-fd-password="XXX_REPLACE_WITH_CLIENT_MONITOR_PASSWORD_XXX" \
    --with-mon-sd-password="XXX_REPLACE_WITH_STORAGE_MONITOR_PASSWORD_XXX" \
    --with-basename="XXX_REPLACE_WITH_LOCAL_HOSTNAME_XXX"

nfe re-l-g
--host=aarch64-redhat-linux-gnu \
--program-prefix= \
--disable-dependency-tracking \
--prefix=/usr \
--exec-prefix=/usr \
--bindir=/usr/bin \
--sbindir=/usr/sbin \
--sysconfdir=/etc \
--datadir=/usr/share \
--includedir=/usr/include \
--libdir=/usr/lib64 \
--libexecdir=/usr/libexec \
--localstatedir=/var \
--sharedstatedir=/var/lib \
--mandir=/usr/share/man \
--infodir=/usr/share/info \
--disable-conio \
--disable-rpath \
--docdir=/usr/share/bacula \
--enable-batch-insert \
--enable-build-dird \
--enable-build-stored \
--enable-includes \
--enable-largefile \
--enable-readline \
--enable-smartalloc \
--sysconfdir=/etc/bacula \
--with-basename=bacula \
--with-bsrdir=/var/spool/bacula \
--with-dir-password=@@DIR_PASSWORD@@ \
--with-fd-password=@@FD_PASSWORD@@ \
--with-hostname=localhost \
--with-logdir=/var/log/bacula \
--with-mon-dir-password=@@MON_DIR_PASSWORD@@ \
--with-mon-fd-password=@@MON_FD_PASSWORD@@ \
--with-mon-sd-password=@@MON_SD_PASSWORD@@ \
--with-mysql --with-openssl \
--with-pid-dir=/var/run \
--with-plugindir=/usr/lib64/bacula \
--with-postgresql \
--with-scriptdir=/usr/libexec/bacula \
--with-sd-password=@@SD_PASSWORD@@ \
--with-smtp-host=localhost \
--with-sqlite3 \
--with-subsys-dir=/var/lock/subsys \
--with-tcp-wrappers \
--with-working-dir=/var/spool/bacula \
--with-x \
--enable-bat
