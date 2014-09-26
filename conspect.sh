apt-get update
apt-get -y upgrade
# Base
apt-get -y install htop mc aptitude zip unzip subversion sysv-rc-conf debconf-utils

# Apache
apt-get -y install apache2 libapache2-mod-php5 apache2-utils mcrypt


# MySQL
MYSQL_ROOT_PASS=Everest8848
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' mysql-server|grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
  echo "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASS" | debconf-set-selections
  echo "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASS" | debconf-set-selections
  export DEBIAN_FRONTEND=noninteractive
  apt-get -y -f install mysql-server
fi

apt-get -y install mysql-client mysql-common
# PHP 5
apt-get -y install python-software-properties
apt-get -y install php5 php5-gd php5-mysql php5-curl php5-cli php5-cgi php5-dev php5-fpm php5-mcrypt
apt-get -y install php5-memcache memcached
# Настройка файрвола
ufw allow 22
ufw allow 80
ufw allow 443
a2enmod rewrite
php5enmod mcrypt
service apache2 restart

# Установка  PHPMyAdmin
echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $MYSQL_ROOT_PASS" | debconf-set-selections
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
export DEBAN_FRONTEND=noninteractive
apt-get install -y -f phpmyadmin

service apache2 restart

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

apt-get -y install build-essential gcc make libpq-dev subversion git

mkdir -p /opt/install; cd /opt/install

git clone https://github.com/unitlinux/AutoBuntu.git
chmod -R 755 AutoBuntu
cd AutoBuntu/Openstack

################################################################################
# PostgreSQL-1C
echo "postgresql-common postgresql-common/obsolete-major boolean true" | debconf-set-selections
apt-get -y install  openssl libssl0.9.8 libossp-uuid16 ssl-cert libxslt1.1 libicu52 libt1-5 t1utils imagemagick unixodbc texlive-base libgfs-1.3-2 postgresql-common

# Увеличиваем максимальный размер сегмента памяти до 1Гб. Для менее мощных машин устанавливают от 64Мб до половины объема ОЗУ (для теста выделим 1Gb):
grep "kernel.shmmax=" /etc/sysctl.conf >/dev/null
if [ $? -ne 0 ]; then
  echo "kernel.shmmax=1073741824" >>/etc/sysctl.conf
  echo "kernel.shmall=1073741824" >>/etc/sysctl.conf
fi
sysctl -p

locale-gen en_US ru_RU ru_RU.UTF-8
export LANG="ru_RU.UTF-8"

mkdir -p /opt/install/PostgreSQL; cd /opt/install/PostgreSQL

wget http://downloads.v8.1c.ru/get/Info/AddCompPostgre/9_2_4_1_1S/postgresql_9_2_4_1_1C_amd64_deb_tar.bz2

tar xvf postgresql_9_2_4_1_1C_amd64_deb_tar.bz2
# Фикс на libicu-4.6
# копируем postgresql-contrib-9.2_9.2.4-1.1C_amd64.deb в папку на сервере, входим в нее
# Распаковываем пакет:
dpkg-deb -x postgresql-contrib-9.2_9.2.4-1.1C_amd64.deb tmpdir
# после:
dpkg-deb -e postgresql-contrib-9.2_9.2.4-1.1C_amd64.deb tmpdir/DEBIAN
# строку libicu46 (>= 4.6.1-1) меняем на libicu52 (>= 4.6.1-1)
sed -i 's/libicu46 /libicu52 /g' ./tmpdir/DEBIAN/control
# и собираем пакет обратно:
dpkg -b tmpdir postgresql-contrib-9.2_9.2.4-1.1C_amd64_fix.deb

dpkg -i postgresql-9.2_9.2.4-1.1C_amd64.deb libpq5_9.2.4-1.1C_amd64.deb postgresql-client-9.2_9.2.4-1.1C_amd64.deb postgresql-contrib-9.2_9.2.4-1.1C_amd64_fix.deb

# Отключаем обновление для пакетов 1C-овского PostgreSQL.

echo "libpq5 hold" | sudo dpkg --set-selections
echo "postgresql-9.2" hold |  dpkg --set-selections
echo "postgresql-client-9.2" hold |  dpkg --set-selections
echo "postgresql-contrib-9.2" hold |  dpkg --set-selections

# После установки нужно еще немного подправить конфигурационный файл,
# как не странно будучи поставленным в пакете 1с он содержит не правильные настройки для обработки экранирующих символов,#и при создании базы 1с выдает ошибки “syntax error at or near “SECOND” at character 127″
# ли “syntax error at or near “SECOND” at character 227″.
# Исправляем в файле /etc/postgresql/9.2/main/postgresql.conf следующие параметры:
# backslash_quote = on
# escape_string_warning = off
# standard_conforming_strings = off
export PGSQL_DATA_DIR="/etc/postgresql/9.2/main"
sed -i -e '/^#backslash_quote/ c\backslash_quote = on' $PGSQL_DATA_DIR/postgresql.conf
sed -i -e '/^#escape_string_warning/ c\escape_string_warning = off' $PGSQL_DATA_DIR/postgresql.conf
sed -i -e '/^#standard_conforming_strings/ c\standard_conforming_strings = off' $PGSQL_DATA_DIR/postgresql.conf

# Настройка доступа к базе данных по сети:
# nano /etc/postgresql/9.2/main/pg_hba.conf
# нужно изменить строки
# hosts      all     all     0.0.0.0/0       trust
# на
# hosts   all     all     0.0.0.0/0       md5

sed -i -e '/^host.*all.*all.*0.0.0.0\/0.*trust/c\\host\tall\t\tall\t\t0.0.0.0\/0\t\tmd5' $PGSQL_DATA_DIR/pg_hba.conf
export PGSQL_ROOT_PASS=Everest8848
sudo -u postgres psql -d postgres -c "ALTER USER postgres WITH PASSWORD '$PGSQL_ROOT_PASS';"

service postgresql restart

# Настройка сетевого экрана

iptables -A INPUT -p tcp --dport 5432 -j ACCEPT
iptables -A INPUT -p udp --dport 5432 -j ACCEPT
service iptables save





# Установка PostgreSQL
apt-get -y install postgresql postgresql-contrib postgresql-common openssl
sudo -u postgres psql -d postgres -c "ALTER USER postgres WITH PASSWORD 'Everest8848';"

# Установка phppgadmin
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
