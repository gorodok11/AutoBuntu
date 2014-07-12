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
