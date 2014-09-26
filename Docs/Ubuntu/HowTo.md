### Как сменить имя хоста (компьютера) в Ubuntu?

Для начала нужно отредактировать файл /etc/hosts:
```
sudo gedit /etc/hosts
```
Выглядеть он должен примерно так:
```
127.0.0.1       localhost
127.0.1.1       hostname
```
Где вместо "hostname" - имя вашего компьютера. Вот именно его то и нужно сменить. Изменяем, сохраняем.

Теперь нужно поправить файл /etc/hostname:
```
sudo gedit /etc/hostname
```
В этом файле содержится только название вашего компьютера и ничего более. Смело изменяем его и сохраняем файл.

Вот и всё. Теперь осталось только перезагрузить сеть и изменения вступят в силу:
```
sudo service hostname restart
sudo service networking restart
```
Можно продолжать работать, но могут возникнуть небольшие проблемы, поэтому лучше будет перезагрузить компьютер.

Скрипт для изменения имени хоста без перезагрузки:
```
!/usr/bin/env bash
NEW_HOSTNAME=$1
echo $NEW_HOSTNAME > /proc/sys/kernel/hostname
sed -i 's/127.0.1.1.*/127.0.1.1\t'"$NEW_HOSTNAME"'/g' /etc/hosts
echo $NEW_HOSTNAME > /etc/hostname
service hostname start

# Take a valid X11 authentication token (xauth list) and replaces the old hostname with the new hostname (sed).
# Then awk puts quotes around the first argument to xauth add because xauth's input and output format are not symmetric.
su $SUDO_USER -c "xauth add $(xauth list | sed 's/^.*\//'"$NEW_HOSTNAME"'\//g' | awk 'NR==1 {sub($1,"\"&\""); print}')"
```

Применение:
```
sudo ./change_hostname.sh new-hostname
```

### Как скачать с сайтов требующих куки-файлы?
Пример с использованием curl:
```
#!/bin/bash

curl -c cookie http://www.cloudbase.it/ws2012r2/ -o 1.html
accept=`cat 1.html | sed -n "s/.*'eulaaccept', _ajax_nonce: '\([^']*\)'.*/\1/p"`
next=`cat 1.html | sed -n "s/.*'eulanext', _ajax_nonce: '\([^']*\)'.*/\1/p"`
curl -b cookie -c cookie 'http://www.cloudbase.it/wp-admin/admin-ajax.php' --data "action=eulaaccept&_ajax_nonce=$accept" -o accept.txt
curl -b cookie -c cookie 'http://www.cloudbase.it/wp-admin/admin-ajax.php' --data "action=eulanext&_ajax_nonce=$next" -o next.txt
curl -C- -b cookie 'http://www.cloudbase.it/euladownload.php?h=kvm' --compressed -o file.qcow2.gz
```

### Как переименовать пользователя?

Для того, чтобы иметь возможность переименовать пользователя, нужно войти либо под другим пользователем, у которого есть возможность выполнять sudo, либо под рутом. Пользователя, который находится в системе, переименовать не получится.

Заходим под другим пользователем и в терминале пошагово выполняем следующие операции:
1. Получаем рутовую консоль

sudo -i


2. Убиваем все оставшиеся процессы пользователя, которого хотим переименовать

killall -u old


3. Смотрим ID пользователя и его группы

id old


4. Меняем имя пользователя

usermod -l new old


5. Меняем его группу

groupmod -n new old


6. Перемещаем домашний каталог

usermod -d /home/new -m new


7. Сверяем ID с теми, которые получены на третьем шаге

id new
