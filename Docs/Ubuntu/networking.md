### Как узнать IP одного из сетевых интерфейсов?
```
ifconfig eth0 | grep inet | awk '{ print $2 }'
```
### Как перезагрузить сетевые интерфейсы?
```
sudo ifdown eth0 && sudo ifup eth0
```
Перезагрузка всех интерфейсов:
```
ifdown --exclude=lo -a && sudo ifup --exclude=lo -a
```
