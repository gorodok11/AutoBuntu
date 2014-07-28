#!/bin/bash
admin=ADMINNAME

# Изменяем системные пароли пользователей
# --> Доработать
# Надо копировать шаблон только пользователям из группы "users"
for user in $( sed n "s/^\([^:]*\):.*:\/bin\/bash$/\1/p" /etc/passwd ); do
  if [ d "/home/${user}" ]; then
    if [ ! "/home/${user}" = "/home/${admin}" ]; then
      <КОПИРУЕМ СЮДА СОДЕРЖИМОЕ ПРЕДЫДУЩЕГО СКРИПТА БЕЗ ПЕРЕМЕННЫХ>
    fi
  fi
done
