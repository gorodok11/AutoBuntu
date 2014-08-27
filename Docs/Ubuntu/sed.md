### Как заменить путь к файлу используя переменную содержащей символ "/"?

Можно заменить делимитатор "/" на ":" или ";" как в следующем примере:
```
export BDIR="/var/www/webacula"
sed -i "s:/usr/share/webacula:$BDIR:g" /etc/apache2/sites-available/webacula.conf
```
### Как заменить текст между двумя маркерами (определенной секции) в файле?
```
lead='^### BEGIN GENERATED CONTENT$'
tail='^### END GENERATED CONTENT$'
sed -e "/$lead/,/$tail/{ /$lead/{p; r insert_file
        }; /$tail/p; d }"  existing_file
```
