!/bin/bash
# Установка WEB интерфейса к PostgreSQL

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root' dude." 1>&2
   exit 1
fi

. ./functions.sh
. ./credentials.sh

function pgadmin-install()
{
  apt-get -y install phppgadmin apache2-utils

  # Настройка
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

  # Обход ошибки "Login disallowed for security reasons." в WEB консоли:
  # Дезактивируем extra_login_security в phppgadmin
  sed -i "/\$conf\['extra_login_security'\]/ s/=.*/= false;/" \
    /etc/phppgadmin/config.inc.php

  htpasswd -i -b -c /etc/phppgadmin/.htpasswd $PG_HT_USER $PG_HT_PASS

  service apache2 restart
}

run_command "Установка PhpPgAdmin:" pgadmin-install

echo "Для доступа к консоли зайдите по адресу http://$SRVR_HOST_NAME/phppgadmin"
