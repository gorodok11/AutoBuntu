#!/bin/bash
# Установка офисных программ

. ./functions.sh
. ./credentials.sh

function libreoffice_install()
{
  add-apt-repository ppa:libreoffice/ppa
  apt-get update
  apt-get -y install libreoffice
}

run_command "Установка LibreOffice" libreoffice_install
