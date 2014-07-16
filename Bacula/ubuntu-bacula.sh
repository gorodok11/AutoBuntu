#!/bin/bash

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

. ./functions.sh
. ./credentials.sh

function bacula_install()
{
  apt-get -y install build-essential gcc make libpq-dev subversion
cd bacula-7.0.4
  wget http://netcologne.dl.sourceforge.net/project/bacula/bacula/$BACULA_VERSION/bacula-$BACULA_VERSION.tar.gz
  tar -zxf bacula-$BACULA_VERSION.tar.gz
  cd bacula-$BACULA_VERSION
  make distclean
  ./configure --with-postgresql --with-openssl
  make
  make install

}

function bacula_pg_config()
{
  # Временно добавим пользователя postgres в группу root для создания базы Bacula
  usermod -a -G root postgres
  sudo adduser postgres sudo
  su - postgres -c /etc/bacula/create_postgresql_database
	su - postgres -c /etc/bacula/make_postgresql_tables
	su - postgres -c /etc/bacula/grant_postgresql_privileges

  sed -i '/^local.*all.*all.*peer/a\\nlocal\tbacula\t\tbacula\t\t\t\t\ttrust' $POSTGRE_HBA_CONF
  sed -i 's/local.*all.*all.*peer/#local\tall\tall\t\t\t\t\tpeer/g' $POSTGRE_HBA_CONF

  service postgresql restart

  sed -i "s/dbname = \"bacula\"; dbuser = \"bacula\"; dbpassword = \"\"/dbname = \"bacula\"; dbuser = \"bacula\"; dbpassword = \"$BACULA_SQL_PASS\"/g" /etc/bacula/bacula-dir.conf
	su - postgres -c "psql -U bacula -d bacula -c \"alter user bacula with password '$BACULA_SQL_PASS';\""

	sed -i 's/local.*bacula.*bacula.*trust/local\tbacula\tbacula\t\t\t\t\tmd5/g' $POSTGRE_HBA_CONF

  service postgresql restart
  # Удаляем пользователя postgres из root группы
  gpasswd -d postgres root
}

function bacula_boot()
{
  # Установка сервисов Bacula
  cp /etc/bacula/bacula-ctl-dir /etc/init.d/bacula-dir
	cp /etc/bacula/bacula-ctl-fd /etc/init.d/bacula-fd
	cp /etc/bacula/bacula-ctl-sd /etc/init.d/bacula-sd
	chmod 755 /etc/init.d/bacula-sd
	chmod 755 /etc/init.d/bacula-fd
	chmod 755 /etc/init.d/bacula-dir
	update-rc.d bacula-sd defaults 90
	update-rc.d bacula-fd defaults 91
	update-rc.d bacula-dir defaults 92
}

function bacula_dir_configuration()
{
    # Файл настроек сложен для восприятия, поэтомй распределим секции по отдельным файлам
    # Предполагается что файл конфигурации содержит 314 строк.
  	num=$(wc -l < /etc/bacula/bacula-dir.conf)
		if [ $num -lt 314 ];then
			return 0
			echo "Возможно файл /etc/bacula/bacula-dir.conf изменен."
		fi
    cp -f /etc/bacula/bacula-dir.conf.backup /etc/bacula/bacula-dir.conf.backup
    cp /etc/bacula/bacula-sd.conf /etc/bacula/bacula-sd.conf.backup
    cp /etc/bacula/bconsole.conf /etc/bacula/bconsole.conf.backup
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

}

function bat_Install()
{
  # Установка BAT
    apt-get install -y bacula-console-qt

  # Удостоверимся что в bat.conf и bconsole.conf записан тот же пароль
    BAT=$(sed -n 9,9p /etc/bacula/bat.conf)
    BCON=$(sed -n 9,9p /etc/bacula/bconsole.conf)

  # Копируем пароль из bconsole.conf в bat.conf
    sed -i "s;$BAT;$BCON;g" /etc/bacula/bat.conf
}

function baculaweb_install()
{
  # Установка WEB клиента bacula-web
  apt-get -y install libapache2-mod-php5 php5-mysql php5-gd
  wget http://www.bacula-web.org/files/bacula-web.org/downloads/bacula-web-6.0.0.tgz
  tar -xzf bacula-web-6.0.0.tgz
  rm -rf bacula-web-6.0.0.tgz
  mv -v bacula-web-6.0.0 $BACULAWEB_DIR
  chown -Rv www-data:www-data $BACULAWEB_DIR
  chmod -Rv u=rx,g=rx,o=rx $BACULAWEB_DIR
  chmod 700 "$BACULAWEB_DIR/application/view/cache"

  # Настройка Bacula-web
  cp -v "$BACULAWEB_DIR/application/config/config.php.sample" "$BACULAWEB_DIR/application/config/config.php"
  chown -v www-data:www-data "$BACULAWEB_DIR/application/config/config.php"

  echo "<?php

// Show inactive clients (false by default)
\$config['show_inactive_clients'] = true;

// Hide empty pools (displayed by default)
\$config['hide_empty_pools'] = false;

// Jobs per page (Jobs report page)
\$config['jobs_per_page']= 25;
// Translations
\$config['language'] = 'en_US';

// PostgreSQL bacula catalog
\$config[0]['label'] = '$SRVR_HOST_NAME';
\$config[0]['host'] = 'localhost';
\$config[0]['login'] = '$BACULA_SQL_USER';
\$config[0]['password'] = '$BACULA_SQL_PASS';
\$config[0]['db_name'] = 'bacula';
\$config[0]['db_type'] = 'pgsql';
\$config[0]['db_port'] = '5432';
?>" >  $BACULAWEB_DIR/application/config/config.php

  service apache2 restart

}

apt-get -y install postfix

run_command "Установка Bacula:" bacula_install
run_command "Настройка Bacula:" bacula_pg_config bacula_boot bacula_dir_configuration
run_command "Установка Bacula-WEB:" baculaweb_install
