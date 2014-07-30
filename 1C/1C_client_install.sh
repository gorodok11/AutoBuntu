#!/bin/bash
# Установка 1С:Предприятие 8.3

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

. ./functions.sh

function 1C_client_install()
{
  # Установка дополнительных пакетов совместимостиget -y install imagemagick unixodbc libgsf-bin t1utils texlive-base

  # Генерируем русскую локаль и задаем переменную среды LANG, именно с ней будет работать скрипт инициализации базы данных.
  locale-gen en_US ru_RU ru_RU.UTF-8
  export LANG="ru_RU.UTF-8"

  wget http://downloads.v8.1c.ru/get/Info/Platform/8_3_5_1088/client.deb64.tar.gz
  tar xvfz client.deb64.tar.gz
  # Примечание:
  # NLS-ы точно не нужно (это для дистрибов где русской кодировки нет, а такие сейчас поискать нужно :))
  # WS-ка нужна только если собираешся веб-сервис публиковать
  # Перечисленные пакеты можно удалить
  sudo dpkg -i 1c*.deb
  # При установке пакетов 1С:Предприятия 8.3 могут быть ошибки «сломанных» связей... исправляем связи:
  apt-get -f install

}

run_command "Установка клиента 1С:Предприятие 8.3:" 1C_client_install

#  вместо ttf2pt1 1С-ке подойдет и ttf2afm
