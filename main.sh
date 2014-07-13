#!/bin/bash
# Файл содержит полный маршрут установки
# Если чего-то не нужно устанавливать, просто удалите или закомментируйте соответствующую строку

. $(cd $(dirname $0) && pwd)/functions.sh

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

#!
echo 0|sed 's909=bO%3g)o19;s0%0aob)]vO0;s()(0eh}=(;s%}%r1="?0^2{%;
s)")@l2h3%"@$);sw%wh]r()$o%!w;sz(z^+.z;sa+a !z" a;sxzxi?v{a)ax;:b;
s/\(\(.\).\)\(\(..\)*\)\(\(.\).\)\(\(..\)*%.*\6.*\2.*\)/\5\1\3\7/;
tb;
s/%.*//;s/.\(.\)/\1/g'

# Необходимо проверить OS на которой работаем, подключение к сети, пользователя под которым работаем,
# удостоверимся что sshd работает и wget доступен.

# Проверяет версию ОС.
# Отображаем меню установки

tput clear

# Move cursor to screen location X,Y (top left is 0,0)
tput cup 1 0
# Created with http://patorjk.com/software/taag/

tput setaf 4
echo "       _         _        ____              _          "
echo "      / \  _   _| |_ ___ | __ ) _   _ _ __ | |_ _   _  "
echo "     / _ \| | | | __/ _ \|  _ \| | | | '_ \| __| | | | "
echo "    / ___ \ |_| | || (_) | |_) | |_| | | | | |_| |_| | "
echo "   /_/   \_\__,_|\__\___/|____/ \__,_|_| |_|\__|\__,_| "
echo "                                                       "
echo "             Igor Frunza gorodok11@gmail.com           "
echo "                          2014                         "
echo "_______________________________________________________"

tput sgr0

tput cup 12 0
# Set bold mode
tput bold
echo "Это скрипт автоматической установки набора программ под "
echo "Ubuntu Server 14.04"

while true; do
     read -p "Приступить к установке? (Y/N):" warncheck
     case $warncheck in
          [Yy]* ) break;;
          [Nn]* ) echo "Отмена."; exit;;
          * ) tput setaf 1;  echo "Пожалуйста ответьте да или нет."; tput sgr0;;
     esac
done

#_______________________________________________________________________

tput setaf 2
print_status "Проверка версии ОС..."
tput sgr0
     release=`lsb_release -r|awk '{print $2}'`
     if [ $release = "14.04" -o $release = "14.10" ]
          then
                   tput setaf 2
  		   echo "Проверка ОС успешна."
                   tput sgr0
          else
               tput setaf 1
               echo "Это не Ubuntu 14.04 или 14.10, скрипт не был протестирован на других платформах."
               tput sgr0
               while true; do
                   read -p "Продолжить? (y/n)" warncheck
                   case $warncheck in
                       [Yy]* ) break;;
                       [Nn]* ) echo "Отмена."; exit;;
                       * ) echo "Пожалуйста ответьте да или нет.";;
                   esac
				done
		echo " "
     fi
#_______________________________________________________________________

print_status "Проверка соединения с интернетом (ping google.com)..."
tput sgr0
     ping google.com -c1 2>&1 >> /dev/null
     if [ $? -eq 0 ]; then
          print_good "Соединение с интернетом установлено!"
     else
          print_error "При проверке связи не удалось обнаружить узел google.com. Пожалуйста проверьте соединение с интернетом или что исходящий ICMP разрешен."
          exit 1
     fi
#_______________________________________________________________________

print_status "Проверяем если sshd работает..."
  if [ $(/bin/ps -ef |/bin/grep sshd |/usr/bin/wc -l) -gt 1 ]
		then
			print_good "sshd работает."
		else
	 		print_error "sshd не работает. Установку можно продолжать, но часто sshd требуется для удаленной настройки и управления компьютером."
	fi
#_______________________________________________________________________

./BaseInstall/ubuntu-update.sh
./BaseInstall/ubuntu-ntp.sh
./BaseInstall/ubuntu-git.sh
./BaseInstall/ubuntu-webmin.sh
./Bacula/ubuntu-bacula.sh
