#!/bin/bash
# Установка 1С:Предприятие 8.3

# Установка 1С
# Качаем с сайта 1C необходимые пакеты и ставим их в папку /opt/install/1C
# mkdir -p /opt/install/{PostgreSQL,1C}
# Ссылку для скачивания ищем на сайте http://users.v8.1c.ru/
# wget http://*.v8.1c.ru/.*./.*./.*./.*./deb64.tar.gz
# Перед закачкой надо авторизироваться на сайте v8.users.1c.ru
# cd /opt/install/1C
# wget http://downloads.v8.1c.ru/get/Info/Platform/8_3_5_1088/deb64.tar.gz
# wget http://downloads.v8.1c.ru/get/Info/Platform/8_3_5_1088/client.deb64.tar.gz

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

. ./functions.sh

function 1C_server_install()
{
  # Установка дополнительных пакетов
  echo 'msttcorefonts msttcorefonts/defoma note' | debconf-set-selections
  echo 'ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula boolean true' | debconf-set-selections
  echo 'ttf-mscorefonts-installer msttcorefonts/present-mscorefonts-eula note' | debconf-set-selections
  export DEBAN_FRONTEND=noninteractive

  apt-get -y install imagemagick unixodbc libgsf-bin t1utils texlive-base libssl0.9.8 libossp-uuid16 libxslt1.1 libicu52 libt1-5 t1utils msttcorefonts ttf-mscorefonts-installer  texlive-base libgfs-1.3-2

  # Делаем симлинк библиотеки:
  ln -s /usr/lib/x86_64-linux-gnu/libMagickWand.so.5 /usr/lib/x86_64-linux-gnu/libMagickWand.so

  # Генерируем русскую локаль и задаем переменную среды LANG, именно с ней будет работать скрипт инициализации базы данных.
  locale-gen en_US ru_RU ru_RU.UTF-8
  export LANG="ru_RU.UTF-8"

  cd /opt/install/1C
  tar xvfz deb64.tar.gz
  wget http://old-releases.ubuntu.com/ubuntu/pool/universe/t/ttf2pt1/ttf2pt1_3.4.4-1.4_amd64.deb
  dpkg -i ttf2pt1_3.4.4-1.4_amd64.deb

  # Примечание:
  # NLS-ы точно не нужно (это для дистрибов где русской кодировки нет, а такие сейчас поискать нужно :))
  # WS-ка нужна только если собираешся веб-сервис публиковать
  # Перечисленные пакеты можно удалить
  dpkg -i 1c*.deb
  # При установке пакетов 1С:Предприятия 8.3 могут быть ошибки «сломанных» связей... исправляем связи:
  # Хотя у меня это не обнаружилось...
  apt-get -f install

  # Для проверки того, все ли пакеты установились корректно выполняем комадну:
  #dpkg -l | grep 1c-enterprise83

  chown -R usr1cv8:grp1cv8 /opt/1C
  # Перезапускаем сервер 1С:
  service srv1cv83 restart
}

function 1C_client_install()
{
  # Установка дополнительных пакетов
  apt-get -y install imagemagick unixodbc libgsf-bin t1utils texlive-base libwebkitgtk-1.0
  apt-get -f install

  # Генерируем русскую локаль и задаем переменную среды LANG, именно с ней будет работать скрипт инициализации базы данных.
  locale-gen en_US ru_RU ru_RU.UTF-8
  export LANG="ru_RU.UTF-8"

  cd /opt/install/1C
  tar xvfz client.deb64.tar.gz
  # Примечание:
  # NLS-ы точно не нужно (это для дистрибов где русской кодировки нет, а такие сейчас поискать нужно :))
  # WS-ка нужна только если собираешся веб-сервис публиковать
  # Перечисленные пакеты можно удалить
  sudo dpkg -i 1c-enterprise83-client*.deb
  # При установке пакетов 1С:Предприятия 8.3 могут быть ошибки «сломанных» связей... исправляем связи:
  apt-get -f install

}

if [ -f /opt/install/1C/deb64.tar.gz ]; then
  run_command "Установка сервера 1С:Предприятие 8.3:" 1C_server_install
else
  print_error "Не найден пакет установки сервера 1C в папке /opt/install/1C"
fi

if [ -f /opt/install/1C/client.deb64.tar.gz ]; then
  run_command "Установка клиента 1С:Предприятие 8.3:" 1C_client_install
else
  print_error "Не найден пакет установки сервера 1C в папке /opt/install/1C"
fi

print_status "Проверка работы сервера 1С:"
service postgresql status
netstat -atn |grep 0.0.0.0:15
ps aux|grep 1c
