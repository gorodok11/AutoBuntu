Для тестирования bacula-web зайдите по адресу
http://yourserveroripaddress/bacula-web/test.php




nano /usr/include/php5/Zend/zend.h
#Нужно в /usr/include/php5/Zend/zend.h в район 320 строки добавить

#define refcount refcount__gc
#define is_ref is_ref__gc

# --> Доработать

nano /usr/include/php5/Zend/zend_API.h
#А в /usr/include/php5/Zend/zend_API.h в район 50 строки
#define object_pp object_ptr

#Paste these lines:
#Alias /webacula /var/www/webacula/html
#<Directory /var/www/webacula/html>
#Options FollowSymLinks
#AllowOverride All
#Order deny,allow
#Allow from All
#</Directory>

service apache2 restart

# Login to web console at http://yourIP/webacula/
