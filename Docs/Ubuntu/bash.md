http://www.opennet.ru/docs/RUS/bash_scripting_guide/

### Как отключить вывод комманды в консоль:
```
linux command > /dev/null 2>&1
```
### Как получить директорию из которой запускается bash скрипт?
```
ROOT_PATH=$(cd $(dirname $0) && pwd)
echo $ROOT_PATH
```
Или:
```
BASE_DIR=$(dirname $(readlink -f $0))
echo $BASE_DIR
```
### Как запустить скрипт из директории на уровень выше?
```
. ./functions.sh
```
### Как отправить письмо с вложением из командной строки?
```
apt-get install mutt
mutt -s “Backup” -a /tmp/logs — webmaster@tutorialarena.com < ./msg
```
### Как закрасить лог файл в консоли?
```
#!/bin/bash

LOG=/usr/local/e220/log/main.log

tail -f ${LOG} | \
sed -u -e 's/<>/\x1B\[31;1m<>\x1B\[37;0m/' | \
sed -u -e 's/^[0-9:-]*/\x1B\[30;1m&\x1B\[37;0m/' | \
sed -u -e 's/Created/\x1B\[34;1mCreated\x1B\[37;0m/' | \
sed -u -e 's/Sent/\x1B\[34;1mSent\x1B\[37;0m/' | \
sed -u -e 's/CRITICAL/\x1B\[31;1mCRITICAL\x1B\[37;0m/' | \
sed -u -e 's/OK/\x1B\[32;1mOK\x1B\[37;0m/' | \
sed -u -e 's/WARNING/\x1B\[33;1mWARNING\x1B\[37;0m/' | \
sed -u -e 's/SOFT/\x1B\[32;1mSOFT\x1B\[37;0m/' | \
sed -u -e 's/HARD/\x1B\[31;1mHARD\x1B\[37;0m/'
```
### Перебор файлов в каталоге

При необходимости перебрать все файлы в каком-либо каталоге и выполнить над ними какие-либо действия, можно воспользоваться простым однострочным циклом:
```
for file in /etc/config/*; do wc -l $file; stat -c %s $file; done
```
Можно использовать и find для рекурсивного поиска и дополнительных фильтров:
```
for file in `find /etc -type f -name "*.conf"`
do
   wc -l $file;
   stat -c %s $file;
done
```
Если выполняется не более одного действия над файлом, можно обойтись без цикла:
```
find /etc -type f | xargs wc -l
```
Если в именах файлов есть пробелы, то добавляем к find параметр -print0:
```
find /etc -type f -print0 | xargs -0 wc -l
```
Во всех примерах вычисляется количество строк в файлах.
