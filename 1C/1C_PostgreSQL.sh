#!/bin/bash
# Установка PostgreSQL-1C

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только из под пользователем 'root'." 1>&2
   exit 1
fi

# Установка зависимостей
apt-get install libssl0.9.8 libossp-uuid16 libxslt1.1 libicu52 libt1-5 t1utils imagemagick unixodbc texlive-base libgfs-1.3-2

# Установка утилит для сборки пакетов из исходников
# Если устанавливаем готовый пакет  PostgreSQL, пропускаем этот шаг
#apt-get -y install linux-headers-`uname -r` binutils pkg-config build-essential
#apt-get -y install libreadline-dev zlib1g-dev

# Качаем с сайта 1C необходимые пакеты Postgre 9.2.4
mkdir -p /opt/install/{PostgreSQL,1C}
cd /opt/install/PostgreSQL
wget http://downloads.v8.1c.ru/get/Info/AddCompPostgre/9_2_4_1_1S/postgresql_9_2_4_1_1C_amd64_deb_tar.bz2
tar xvf postgresql_9_2_4_1_1C_amd64_deb_tar.bz2

# Этот пакет не обязателен
#wget http://downloads.v8.1c.ru/get/Info/AddCompPostgre/9_2_4_1_1S/postgresql_9_2_4_1_1C_amd64_addon_deb_tar.bz2
#tar xvf postgresql_9_2_4_1_1C_amd64_addon_deb_tar.bz2

wget http://mirror.yandex.ru/ubuntu/pool/main/p/postgresql-common/postgresql-common_154_all.deb
# (на момент написания статьи на сайте была доступна лишь версия для lucid,
# которая ломает logrotate, поэтому этот пакет скачивал отдельно)!

# Устанавливаем их именно в такой последовательности:
dpkg -i libpq5_9.2.4-1.1C_amd64.deb
dpkg -i postgresql-client-9.2_9.2.4-1.1C_amd64.deb
dpkg -i postgresql-common_154_all.deb
dpkg -i postgresql-contrib-9.2_9.2.4-1.1C_amd64.deb
dpkg -i postgresql-9.2_9.2.4-1.1C_amd64.deb

# Pin a specific version of PostgreSQL
echo "postgresql hold" | sudo dpkg --set-selections
echo "postgresql-common hold" | sudo dpkg --set-selections
echo "postgresql-client hold" | sudo dpkg --set-selections
echo "postgresql-contrib hold" | sudo dpkg --set-selections
echo "libpq5 hold" | sudo dpkg --set-selections

# Настройка сетевого экрана
