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
  apt-get -y install --no-install-recommends lubuntu-desktop
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

function clean_programs()
{
  apt-get -y remove --auto-remove audacious guvcview xfburn gnome-mplayer transmission
  apt-get -y remove --auto-remove abiword gnumeric
}

run_command "Установка рабочего стола LXDE:" lubuntu_install
run_command "Удаление ненужных програм:" clean_programs
