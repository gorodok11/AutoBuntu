#!/bin/bash
# Файл содержит глобальные функции
# Использование:
# Добавить в начале скрипта
# . $(cd $(dirname $0) && pwd)/functions.sh

#_______________________________________________________________________
# Вывод статусов
# print_status "Проверка прав пользователя."
function print_status ()
{
    echo -e "\x1B[01;34m[*]\x1B[0m $1"
}

function print_good ()
{
    echo -e "\x1B[01;32m[*]\x1B[0m $1"
}

function print_error ()
{
    echo -e "\x1B[01;31m[*]\x1B[0m $1"
}

function print_notification ()
{
	echo -e "\x1B[01;33m[*]\x1B[0m $1"
}
#_______________________________________________________________________
#Быстрый и простой способ повторно использовать функцию apt-get.
install_packages()
{
 echo "Устанавливаем пакеты: ${@}"
 apt-get update && apt-get install -y ${@}
 if [ $? -eq 0 ]; then
  echo "Пакеты успешно установлены."
 else
  echo "Пакеты не удалось установить!"
  exit 1
 fi
}
#_______________________________________________________________________
# Запуск команды
# Использование:
# run_command "Installing MySQL server" apt-get install -y mysql-server python-mysqldb
function run_command()
{
	echo -n "$1..."
        shift
        STDOUT=$($* 2>&1) && (echo "DONE") || (echo "ERROR"; echo $STDOUT; kill -9 $$)
}
#_______________________________________________________________________
# Распаковка архивов
# Использование:
# extract(filename.tar.gz)
extract ()
{
    if [ -f "$1" ]
        then
            case "$1" in
                 *.tar.bz2) tar xvjf "$1" ;;
                 *.tar.gz) tar xzvf "$1" ;;
                 *.bz2) bunzip2 -v "$1" ;;
                 *.deb) ar xv "$1" ;;
                 *.gz) gunzip -v "$1" ;;
                 *.rar) unrar xv "$1" ;;
                 *.rpm) rpm2cpio -v "$1" | cpio --quiet -i --make-directories ;;
                 *.tar) tar xfv "$1" ;;
                 *.tbz2) tar xjfv "$1" ;;
                 *.tgz) tar xzfv "$1" ;;
                 *.zip) unzip "$1" ;;
                 *.z) uncompress -v "$1" ;;
                 *.7z) 7z xv "$1" ;;
                 *) echo "'$1' не может быть распакован через extract()." ;;
        esac
    else
        echo "'$1' - неподдерживаемый файл!"
    fi
}
