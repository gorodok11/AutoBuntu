# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только из под пользователя'root' dude." 1>&2
   exit 1
fi
apt-get install php-fpdf
ln -s /usr/share/php/fpdf /var/www/fpdf
