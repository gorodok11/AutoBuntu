#!/bin/bash
# Установка офисных программ

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

. ./functions.sh
. ./credentials.sh

function libreoffice_install()
{
  add-apt-repository ppa:libreoffice/ppa -y
  apt-get update
  apt-get -y install libreoffice
  apt-get -y install libreoffice-l10n-ru
}

function doublecmd_install()
{

  add-apt-repository ppa:alexx2000/doublecmd -y
  apt-get update
  apt-get -y install doublecmd-qt
}

run_command "Установка LibreOffice:" libreoffice_install
run_command "Установка PDF принтера CUPS-PDF:"apt-get -y install cups-pdf
