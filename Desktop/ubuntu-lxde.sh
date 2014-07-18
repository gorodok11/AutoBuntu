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
  sed -i 's/XKBLAYOUT="us"/XKBLAYOUT="us,ru"/g' /etc/default/keyboard
  # Отключаем скринсэйвер
  echo 'mode: off' > ~/.xscreensaver

}

function clean_programs()
{
  apt-get -y remove --auto-remove audacious guvcview xfburn gnome-mplayer transmission
  apt-get -y remove --auto-remove abiword gnumeric
}

run_command "Установка рабочего стола LXDE:" lubuntu_install
run_command "Удаление ненужных програм:" clean_programs
