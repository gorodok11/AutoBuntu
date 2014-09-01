# Установка Webmin

apt-get -y install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl libdigest-md5-perl
touch /etc/apt/sources.list.d/webmin.list
echo "# Webmin
  deb http://download.webmin.com/download/repository sarge contrib
  deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list

wget http://www.webmin.com/jcameron-key.asc -O- | apt-key add -
apt-get update

apt-get install webmin -y
ufw allow 10000

apt-get -y install htop mc aptitude zip unzip subversion sysv-rc-conf debconf-utils
apt-get -y install build-essential gcc make libpq-dev subversion


apt-get -y install postgresql postgresql-contrib postgresql-common openssl
sudo -u postgres psql -d postgres -c "ALTER USER postgres WITH PASSWORD 'Everest8848';"

apt-get -y install phppgadmin apache2-utils
sed -i "s/^# allow from all/allow from all/" /etc/apache2/conf.d/phppgadmin
mv /etc/apache2/conf.d/phppgadmin /etc/apache2/conf-enabled/phppgadmin.conf

echo '
<Directory /usr/share/phppgadmin>
      AuthUserFile /etc/phppgadmin/.htpasswd
      AuthName "Restricted Area"
      AuthType Basic
      require valid-user
</Directory>
' >> /etc/apache2/sites-enabled/phppgadmin.conf

chown -R www-data:www-data /usr/share/phppgadmin
chown -R www-data:www-data /etc/phppgadmin
sed -i "/\$conf\['extra_login_security'\]/ s/=.*/= false;/" \
  /etc/phppgadmin/config.inc.php


perl -MCPAN -e"install DBD::Pg"

export PG_HT_USER="PGadmin"
export PG_HT_PASS="Everest8848"

htpasswd -i -b -c /etc/phppgadmin/.htpasswd $PG_HT_USER $PG_HT_PASS
service apache2 restart


export BACULA_VERSION=7.0.5
export BACULA_SQL_PASS="Everest8848"

mkdir -p /opt/install/bacula
cd /opt/install/bacula

wget http://netcologne.dl.sourceforge.net/project/bacula/bacula/$BACULA_VERSION/bacula-$BACULA_VERSION.tar.gz
tar -zxf bacula-$BACULA_VERSION.tar.gz
cd bacula-$BACULA_VERSION
make distclean
./configure --with-postgresql --with-openssl
make
make install

usermod -a -G root postgres
sudo adduser postgres sudo

su - postgres -c /etc/bacula/create_postgresql_database
su - postgres -c /etc/bacula/make_postgresql_tables
su - postgres -c /etc/bacula/grant_postgresql_privileges

export PGSQL_DATA_DIR="/etc/postgresql/9.3/main"

cp $PGSQL_DATA_DIR/pg_hba.conf $PGSQL_DATA_DIR/pg_hba.conf.back
sed -i '/^local.*all.*all.*peer/a\\nlocal\tbacula\t\tbacula\t\t\t\t\ttrust' $PGSQL_DATA_DIR/pg_hba.conf
sed -i 's/local.*all.*all.*peer/#local\tall\tall\t\t\t\t\tpeer/g' $PGSQL_DATA_DIR/pg_hba.conf

service postgresql restart

sed -i "s/dbname = \"bacula\"; dbuser = \"bacula\"; dbpassword = \"\"/dbname = \"bacula\"; dbuser = \"bacula\"; dbpassword = \"$BACULA_SQL_PASS\"/g" /etc/bacula/bacula-dir.conf
su - postgres -c "psql -U bacula -d bacula -c \"alter user bacula with password '$BACULA_SQL_PASS';\""
sed -i 's/local.*bacula.*bacula.*trust/local\tbacula\tbacula\t\t\t\t\tmd5/g' $PGSQL_DATA_DIR/pg_hba.conf

cp /etc/bacula/bacula-ctl-dir /etc/init.d/bacula-dir
cp /etc/bacula/bacula-ctl-fd /etc/init.d/bacula-fd
cp /etc/bacula/bacula-ctl-sd /etc/init.d/bacula-sd
chmod 755 /etc/init.d/bacula-sd
chmod 755 /etc/init.d/bacula-fd
chmod 755 /etc/init.d/bacula-dir
update-rc.d bacula-sd defaults 90
update-rc.d bacula-fd defaults 91
update-rc.d bacula-dir defaults 92

cp -f /etc/bacula/bacula-dir.conf /etc/bacula/bacula-dir.conf.backup
cp -f /etc/bacula/bacula-sd.conf /etc/bacula/bacula-sd.conf.backup
cp -f /etc/bacula/bconsole.conf /etc/bacula/bconsole.conf.backup

sed -n 166,176p /etc/bacula/bacula-dir.conf > /etc/bacula/clients.conf
sed -n '99,105p;120,121p;127,137p;155,165p' /etc/bacula/bacula-dir.conf > /etc/bacula/filesets.conf
sed -n '26,39p;66,96p' /etc/bacula/bacula-dir.conf > /etc/bacula/jobs.conf
sed -n 278,306p /etc/bacula/bacula-dir.conf > /etc/bacula/pools.conf
sed -n 139,153p /etc/bacula/bacula-dir.conf > /etc/bacula/schedules.conf
sed -n 194,204p /etc/bacula/bacula-dir.conf > /etc/bacula/storage.conf
sed -i "26,231d;237,238d;241,252d;258,262d;267,269d;278,310d" /etc/bacula/bacula-dir.conf

sed -i '26i\# Include configs with @ symbol:\
@/etc/bacula/clients.conf\
@/etc/bacula/filesets.conf\
@/etc/bacula/jobs.conf\
@/etc/bacula/pools.conf\
@/etc/bacula/schedules.conf\
@/etc/bacula/storage.conf\n' /etc/bacula/bacula-dir.conf

sed -i '10i\  Label Format = "Default-${Year}_${Month}_${Day}"' /etc/bacula/pools.conf
sed -i 's/^.*Label Format.*/  Label Format = "Default-${Year}_${Month}_${Day}"/g' /etc/bacula/pools.conf

SD=$(sed -n 14p /etc/bacula/bacula-sd.conf)
STOR=$(sed -n 3p /etc/bacula/storage.conf)

apt-get install -y bacula-console-qt

BAT=$(sed -n 9,9p /etc/bacula/bat.conf)
BCON=$(sed -n 9,9p /etc/bacula/bconsole.conf)

sed -i "s;$BAT;$BCON;g" /etc/bacula/bat.conf
