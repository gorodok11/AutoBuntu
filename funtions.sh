#!/bin/bash
# Файл содержит глобальные функции
# Использование:
# Добавить в начале скрипта
# . $(dirname $(readlink -f $0))/functions.sh

# Убедимся что находимся под рутом
if [ "$(id -u)" != "0" ]; then
   echo "Скрипт установки работает только под пользователем 'root'." 1>&2
   exit 1
fi

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

# Запуск команды
# Использование:
# run_command "Installing MySQL server" apt-get install -y mysql-server python-mysqldb
function run_command()
{
	echo -n "$1..."
        shift
        STDOUT=$($* 2>&1) && (echo "DONE") || (echo "ERROR"; echo $STDOUT; kill -9 $$)
}

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
