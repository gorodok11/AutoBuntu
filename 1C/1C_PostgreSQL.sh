#!/bin/bash
# Установка PostgreSQL-1C

# Качаем с сайта 1C необходимые пакеты Postgre 9.2.4 и ставим их в папку /opt/install/PostgreSQL
# mkdir -p /opt/install/{PostgreSQL,1C}
# Перед закачкой надо авторизироваться на сайте v8.users.1c.ru
# Или скачайте с вашего файлообменника...
# wget http://downloads.v8.1c.ru/get/Info/AddCompPostgre/9_2_4_1_1S/postgresql_9_2_4_1_1C_amd64_deb_tar.bz2

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

. ./functions.sh
. ./credentials.sh

function postgres_install()
{

echo "postgresql-common postgresql-common/obsolete-major boolean true" | debconf-set-selections
# Установка зависимостей
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

# Установка утилит для сборки пакетов из исходников
# Если устанавливаем готовый пакет  PostgreSQL, пропускаем этот шаг
#apt-get -y install linux-headers-`uname -r` binutils pkg-config build-essential
#apt-get -y install libreadline-dev zlib1g-dev

cd /opt/install/PostgreSQL

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
sed -i -e '/^#backslash_quote/ c\backslash_quote = on' $PGSQL_DATA_DIR/postgresql.conf
sed -i -e '/^#escape_string_warning/ c\escape_string_warning = off' $PGSQL_DATA_DIR/postgresql.conf
sed -i -e '/^#standard_conforming_strings/ c\standard_conforming_strings = off' $PGSQL_DATA_DIR/postgresql.conf

# Настройка доступа к базе данных по сети:
# nano $PGSQL_DATA_DIR/pg_hba.conf
# нужно изменить строки
# hosts      all     all     0.0.0.0/0       trust
# на
# hosts   all     all     0.0.0.0/0       md5

sed -i -e '/^host.*all.*all.*0.0.0.0\/0.*trust/c\\host\tall\t\tall\t\t0.0.0.0\/0\t\tmd5' $PGSQL_DATA_DIR/pg_hba.conf

sudo -u postgres psql -d postgres -c "ALTER USER postgres WITH PASSWORD '$PGSQL_ROOT_PASS';"

service postgresql restart

# Настройка сетевого экрана



# Инициализация базы данных в другой директории
# По умолчанию база находится в папке /var/lib/postgresql/9.2/main
# Чтобы использовать другую папку /var/lib/pgsql/data сделаем следующие шаги
# export PGSQL_DATA_DIR="/var/lib/pgsql/data"
#  mkdir -p $PGSQL_DATA_DIR
#  hown postgres:postgres $PGSQL_DATA_DIR
# chmod 700 $PGSQL_DATA_DIR
# sudo -u postgres /usr/lib/postgresql/9.2/bin/initdb -D $PGSQL_DATA_DIR --locale=ru_RU.UTF-8

# Если в конфиге postgres установлено использование ssl (по умолчанию это так):
# ln -s /etc/ssl/certs/ssl-cert-snakeoil.pem $PGSQL_DATA_DIR/server.crt
# ln -s /etc/ssl/private/ssl-cert-snakeoil.key $PGSQL_DATA_DIR/server.key
# Настройка параметров $PGSQL_DATA_DIR/pg_hba.conf как указано выше
# service postgresql restart

}

# Проверяем есть ли пакет установки PostgreSQL
if [ -f /opt/install/PostgreSQL/postgresql_9_2_4_1_1C_amd64_deb_tar.bz2 ]; then
#  run_command "Установка PostgreSQL:" postgres_install
  postgres_install
  print_status "Проверка работы сервера PostgreSQL:"
  service postgresql status
  netstat -atn|grep 5432
  ps aux|grep 1c
else
 print_error "Не найден пакет установки PostgreSQL в папке /opt/install/PostgreSQL/"
fi

if [ -f /opt/install/PostgreSQL/postgresql_9_2_4_1_1C_amd64_deb_tar.bz2 ]; then
  echo 1
else
  echo 2
fi

# Для оптимизации конфига под конф. сервера есть утилита pg_tune
# Еще есть неплохая статья http://wiki.etersoft.ru/PostgreSQL/Optimum?v=xnq
# Последнее время я использую Valentina Studio для работы с postgresql на linux.
# Очень хороший и бесплатный инструмент, рекомендую посмотреть.
# http://www.valentina-db.com/en/valentina-studio-overview
