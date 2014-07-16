#!/bin/bash

# Configure script environment
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
export PATH=/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin
set -e      # Exit on most errors
set -o nounset  # Exit on referncing unset variables
unalias -a  # Drop all aliases

# Configuration variables
# ~~~~~~~~~~~~~~~~~~~~~~~
readonly bver=5.0.3
readonly email=root@localhost
readonly group=bacula
readonly password=some_password
readonly patch=/home/c/d/Repository/src/bacula-5.0.3-libz.patch
readonly prefix=/opt/bacula
readonly targz=/home/c/d/Repository/src/bacula-$bver.tar.gz
readonly user=bacula

# Unpack source archive
# ~~~~~~~~~~~~~~~~~~~~~
cd /tmp \
    && rm -fr bacula \
    && mkdir bacula \
    && cp $targz bacula \
    && cd bacula \
    && tar -zxvf ${targz##*/}

# Patching
# ~~~~~~~~
if [[ $patch != '' ]]; then
    cd /tmp/bacula/bacula-$bver
    cp $patch .
    patch -p1 < ${patch##*/}
fi

# Configure
# ~~~~~~~~~
cd /tmp/bacula/bacula-$bver
CFLAGS="-g -O2 -Wall" \
        ./configure \
        --docdir=$prefix/html \
        --disable-libtool \
        --enable-bat \
        --enable-batch-insert \
        --enable-readline \
        --enable-smartalloc \
        --enable-static-dir \
        --enable-static-fd \
        --enable-static-sd \
        --enable-tray-monitor \
        --htmldir=$prefix/html \
        --libdir=$prefix/lib \
        --mandir=/usr/man \
        --sbindir=$prefix/bin \
        --sysconfdir=$prefix/etc \
        --with-archivedir=/srv/bacula \
        --with-baseport=9101 \
        --with-dir-group=$group \
        --with-dir-password=$password \
        --with-dir-user=$user \
        --with-dump-email=$email \
        --with-fd-password=$password \
        --with-job-email=$email \
        --with-mon-dir-password=$password \
        --with-mon-fd-password=$password \
        --with-mon-sd-password=$password \
        --with-mysql \
        --with-pid-dir=$prefix/working \
        --with-plugindir=$prefix/plugins \
        --with-scriptdir=$prefix/scripts \
        --with-sd-group=$group \
        --with-sd-password=$password \
        --with-sd-user=$user \
        --with-smtp-host=localhost \
        --with-subsys-dir=$prefix/working \
        --with-working-dir=$prefix/working

# Make
# ~~~~
echo 'Make? (Ctrl+C to quit now; any other response runs make)'
read
make
make_rc=$?
[[ $make_rc -ne 0 ]] && exit $make_rc

# Make install
# ~~~~~~~~~~~~
echo 'Make install? (Ctrl+C to quit now; any other response runs make install)'
read
make install
make_rc=$?
[[ $make_rc -ne 0 ]] && exit $make_rc

# Groups fix
# ~~~~~~~~~~
echo "${0##*/}: 'make install' completed.  Setting groups on some scripts and binaries"
chgrp $group $prefix/scripts/* || exit 1
chgrp $group $prefix/bin/* || exit 1
chgrp root $prefix/bin/*bacula-fd || exit 1
echo "${0##*/}: Groups set on some scripts and binaries"

# logrotate configuration file
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# (sample was installed with Bacula 5.0.2 but is not with 5.0.3)
echo "${0##*/}: Creating logrotate configuration file"
echo "$prefix/working/log {
    monthly
    rotate 5
    notifempty
    missingok
}" > /etc/logrotate.d/bacula || exit 1
chmod 644 /etc/logrotate.d/bacula || exit 1
echo "${0##*/}: logrotate configuration file created"

echo "${0##*/}: logrotate configuration file created.  All done"
exit 0
