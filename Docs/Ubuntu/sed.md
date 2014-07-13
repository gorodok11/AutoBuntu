### Как заменить путь к файлу используя переменную содержащей символ "/"?

Можно заменить делимитатор "/" на ":" как в следующем примере:
```
export BDIR="/var/www/webacula"
sed -i "s:/usr/share/webacula:$BDIR:g" /etc/apache2/sites-available/webacula.conf
```
