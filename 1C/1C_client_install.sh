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

  Увичаем максимальный размер сегмента памяти до 1Гб. Для менее мощных машин устанавливают от 64Мб до половины объема ОЗУ (для теста выделим 1Gb):
  echo "kernel.shmmax=1073741824" >>/etc/sysctl.conf
  sysctl -p
  # Генерируем русскую локаль и задаем переменную среды LANG, именно с ней будет работать скрипт инициализации базы данных.
  locale-gen en_US ru_RU ru_RU.UTF-8
  export LANG="ru_RU.UTF-8"

  wgetttp:doloads.v8.1c.ru/get/Info/Platform/8_3_4_496/client.deb64.tar.gz
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