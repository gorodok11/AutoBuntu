#!/bin/bash
# Установка окружения рабочего стола LXDE

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

. ./functions.sh

function lubuntu_install()
{
  apt-get -y install --no-install-recommends lubuntu-desktop lxde-common
  # Добавляем русскую клавиатуру
  sed -i 's:^XKBMODEL=.*:XKBMODEL="pc105":' /etc/default/keyboard
  sed -i 's:^XKBLAYOUT=.*:XKBLAYOUT="us,ru":' /etc/default/keyboard
  sed -i 's:^XKBVARIANT=.*:XKBVARIANT=",":' /etc/default/keyboard
  sed -i 's:^XKBOPTIONS=.*:XKBOPTIONS="grp\:alt_shift_toggle,terminate\:ctrl_alt_bksp,grp_led\:scroll":' /etc/default/keyboard

  dpkg-reconfigure -f noninteractive keyboard-configuration
  # Отключаем скринсэйвер
  echo 'mode: off' > ~/.xscreensaver
  echo 'mode: off' > /home/$SRVR_USER_NAME/.xscreensaver

}

function lxde_utils()
{
 apt-get -y --force-yes install bc cifs-utils coreutils cron cups cups-bsd cups-client curl dbus-x11 \
expect findutils foomatic-db foomatic-db-engine gawk grep libc-bin login logrotate netcat openssl \
psmisc python sed sudo util-linux x11-utils x11-xkb-utils x11-xserver-utils xauth zenity \
libasound2 libfreetype6 libjpeg8 libpng12-0 libx11-6 libxcomposite1 \
libxdamage1 libxfixes3 libxmu6 libxmuu1 libxpm4 libxrandr2 libxtst6 \
xfonts-base xkb-data zlib1g
}

run_command "Установка рабочего стола LXDE:" lubuntu_install
run_command "Установка дополнительных пакетов рабочего стола:" lxde_utils
