#!/bin/bash
# Установка X11RDP

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

. ./functions.sh
. ./credentials.sh

echo -e "\x1B[01;33mЭто займет продолжительное время, примерно 60 мин! \x1B[0m"
# С сайта http://scarygliders.net/ берем адрес скрипта для автоматической компиляции XRDP
# из исходников самой последней доступной версии.
# На момент написания статьи это можно было сделать так:
apt-get -y install git
git clone https://github.com/scarygliders/X11RDP-o-Matic.git
cd X11RDP-o-Matic
./X11rdp-o-matic.sh --justdoit
# Стартует долгий процесс скачивания, проверки и компиляции модулей для xrdp, обязательно нужно дождатся завершения процедуры...
# В папке /X11RDP-o-Matic/packages/ лежат уже готовые собранные пакеты x11rdp_0.7.0-1_amd64.deb, xrdp_0.7.0-1_amd64.deb,
# пригодятся при переинсталированнии сервера без необходимости еще раз компилировать и собирать xrdp из исходников.
# Проверяем установку xrdp:
# sudo service xrdp restart
/etc/init.d/xrdp restart
clear
#echo "Проверка работы XRDP:"
#netstat -lntp |grep 3389
# Ставим xrdp в автозагрузку:
update-rc.d xrdp defaults
update-rc.d xrdp enable
# Там же в папке /X11RDP-o-Matic/ находится скрипт создания файла *.xsession с командой startlxde
# для запуска LXDE при подключении пользователей:
./RDPsesconfig.sh

echo lxsession -s Lubuntu -e LXDE > ~/.xsession
echo lxsession -s Lubuntu -e LXDE > /home/$SRVR_USER_NAME/.xsession

chmod 755 ~/.xsession

# Настраиваем «скелеты» для пользователей:
# настройки lxde
cp -R -f -b /home/$SRVR_USER_NAME/.config/ /etc/skel/
# Содержимое рабочего стола
cp -R -f -b /home/$SRVR_USER_NAME/Desktop/ /etc/skel/
cp -R -f -b '/home/'$SRVR_USER_NAME'/Рабочий стол/' /etc/skel/

# Решение проблемы с раскладкой клавиатуры в терминале:
#sed -i".bkp" '10i\if [ -r /etc/default/locale ]; then\
#. /etc/default/locale\
#export LANG LANGUAGE\
#fi\
#setxkbmap -layout "us,ru" -model "pc105" -option "grp:alt_shift_toggle,grp_led:scroll"' /etc/X11/Xsession

#Решение проблемы переключения раскладок
# Добавляем в /etc/X11/Xsession после set -e в районе 10-й строки:
sed -i".bkp" '10i\## Для корретного определения локали\
if [ -r /etc/default/locale ]; then\
. /etc/default/locale\
export LANG LANGUAGE\
fi\
## Для корретной работы переключения раскладок клавиатуры по alt + shift\
setxkbmap -layout "us,ru" -model "pc105" -option "grp:alt_shift_toggle,grp_led:scroll' /etc/X11/Xsession

# Здесь будет храниться скрипт переключения раскладок клавиатуры
mkdir -p /home/X11rdp
echo '#!/bin/bash\
setxkbmap -layout "us,ru" -model "pc105" -option "grp:alt_shift_toggle,grp_led:scroll"' > /home/X11rdp/set-kb-layout.sh

echo 'xterm –e /home/X11rdp/set-kb-layout.sh' >> /home/rootik/.config/lxsession/Lubuntu/autostart
echo 'xterm –e /home/X11rdp/set-kb-layout.sh' >> /etc/xdg/lxsession/Lubuntu/autostart
chown -R :users /home/X11rdp/set-kb-layout.sh
chmod 755 /home/X11rdp/set-kb-layout.sh

echo 'LANG=ru_RU.UTF-8' > /etc/default/locale
echo 'LANGUAGE=ru:en' >> /etc/default/locale
echo 'MDM_LANG=ru_RU.UTF-8' >> /etc/default/locale

echo "mode:off" > /home/.xscreensaver


# Если нужно более 10-и подключенных одновременно клиентов,
# тогда увеличиваем значение записанное в опцию MaxSessions в секции
# Sessions файла /etc/xrdp/sesman.ini.
# Для 50-и пользователей это будет выглядеть так:
sed -i 's/^MaxSessions.*/MaxSessions=40/g' /etc/xrdp/sesman.ini

# Копируем и изменяем RSA ключи, это необходимо для RDP сессий:
cp -f /etc/xrdp/rsakeys.ini /usr/share/doc/xrdp/
chmod 600 /usr/share/doc/xrdp/rsakeys.ini
chown xrdp:xrdp /usr/share/doc/xrdp/rsakeys.ini

# Автозапуск программы при начале сессии:
# В файле /home/%username%/.session указать строку exec /path/to/script/run/firefox командой (пример!):
# echo 'exec /path/to/script/run/firefox' > /home/%username%/.session

# Создание и настройка пользователей
# Группа для администраторов терминала - tsadmins
# Группа пользователей терминала - tsusers
# Группы прописываются в файле /etc/xrdp/sesman.ini под парметрами:
# TerminalServerUsers=tsusers
# TerminalServerAdmins=tsadmins

echo "Теперь нужно перезагружать компьютер дважды."
echo "Для этого наберите в терминале:"
echo "sudo shutdown -r now"
