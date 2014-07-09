### Как узнать версию пакета:
Для учтановленных пакетов можно использовать следующую команду:
```
root@Ubuntu:~$  dpkg -l apache2
Желаемый=неизвестно[u]/установить[i]/удалить[r]/вычистить[p]/зафиксировать[h]
| Состояние=не[n]/установлен[i]/настроен[c]/распакован[U]/частично настроен[F]/
            частично установлен[H]/trig-aWait/Trig-pend
|/ Ошибка?=(нет)/требуется переустановка[R] (верхний регистр
в полях состояния и ошибки указывает на ненормальную ситуацию)
||/ Имя               Версия                Архитектура           Описание
+++-=================-=====================-=====================-====================
ii  apache2           2.4.7-1ubuntu4        amd64                 Apache HTTP Server
```
Если нам необходимо узнать версию неустановленного пакета можно использовать следующие варианты:
```
root@Ubuntu:~$ apt-cache policy nmap
nmap:
  Установлен: (отсутствует)
  Кандидат:   6.40-0.2ubuntu1
  Таблица версий:
     6.40-0.2ubuntu1 0
        500 http://ru.archive.ubuntu.com/ubuntu/ trusty/main amd64 Packages
```
Или:
```
root@Ubuntu:~$ apt-cache show nmap
Package: nmap
Priority: extra
Section: net
Installed-Size: 17179
Maintainer: LaMont Jones <lamont@debian.org>
Architecture: amd64
Version: 6.40-0.2ubuntu1
Replaces: ndiff
Provides: ndiff
Depends: libc6 (>= 2.15), libgcc1 (>= 1:4.1.1), liblinear1 (>= 1.6), liblua5.2-0, libpcap0.8 (>= 0.9.8), libpcre3, libssl1.0.0 (>= 1.0.0), libstdc++6 (>= 4.6), python:any
Conflicts: ndiff
Filename: pool/main/n/nmap/nmap_6.40-0.2ubuntu1_amd64.deb
Size: 3890560
MD5sum: b21837e6f61317477c58bc05ed8cfd24
SHA1: f654bd9f0adf28d7090ab143c59738ee6d37a8bf
SHA256: 39f664f3be465292c49e250c80dd7f1ecbc9ce557921e6b24ebd160a9fbabfc1
Description-ru: сетевой сканер
 Nmap — утилита для исследования сети и аудита её защищённости. Она
 поддерживает ping-сканирование (определяет включён ли хост), различные
 техники сканирования портов, определение версий (служебных протоколов и
 служб закреплённых за портами) и TCP/IP дактилоскопию (идентификацию ОС
 или устройства удалённого хоста). Nmap также предоставляет настраиваемые
 характеристики целевого объекта и порта, ложное/скрытое сканирование,
 sunRPC-сканирование и прочее. Поддерживаются большинство Unix и Windows
 платформ в режимах графического интерфейса и командной строки. Также
 поддерживаются некоторые популярные наладонные устройства, включая Sharp
 Zaurus и iPAQ.
Description-md5: bc417f4c1fdba7d8d9b0ca8a2a90b7a8
Bugs: https://bugs.launchpad.net/ubuntu/+filebug
Origin: Ubuntu
Supported: 5y

```
