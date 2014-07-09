### Как узнать IP одного из сетевых интерфейсов?
```
ifconfig eth0 | grep inet | awk '{ print $2 }'
```
