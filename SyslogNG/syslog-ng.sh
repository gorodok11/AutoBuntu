#!/bin/bash
# Краткое описание скрипта

# Иипорт файла функций
. ./functions.sh

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root' dude." 1>&2
   exit 1
fi

# Произведем установку syslog-ng из репозитариев Ubuntu
apt-get -y install syslog-ng syslog-ng-core

# Создадим резервную копию конфигурационного файла который будем править:
cp /etc/syslog-ng/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf.backup

sudo touch /var/log/zyxel_internet_zywall.log

# После этого займемся редактированием и добавляем туда следующие строки:
nano /etc/syslog-ng/syslog-ng.conf

# настраиваем новый источник — сеть.
source s_udp {
udp();
};

# определяем новое хранилище логов с именем df_zyxel.
# всё что будет направляться в это хранилище будет
# складываться в файл /var/log/zyxel_internet_zywall.log.
destination df_zyxel {
file("/var/log/zyxel_internet_zywall.log");
};

# определяем новый фильтр. фильтровать будем по адресу клиента.
# здесь нужно указать ip-адрес интернет-центра
filter f_zyxel {
  host('192.168.1.9');
};

# настраиваем логирование информации с источника s_udp,
# попадающей под правила фильтра f_zyxel, в хранилище df_zyxel
log {
source(s_udp);
filter(f_zyxel);
destination(df_zyxel);
};

#После этого нужно перезапустить syslog-ng:
invoke-rc.d syslog-ng restart

# Проверяем, работает ли сервис в системе:
netstat -anp | grep syslog-ng

# Далее заходим в веб-интерфейс интернет-центра ZyXEL и настраивем отправку журналов на наш лог-сервер

# Смотрим в реальном времени, что пишется в лог:
sudo tail -f /var/log/zyxel_internet_zywall.log
