#!/bin/bash

# Запуск redsocks
redsocks -c /etc/redsocks.conf &
echo "Redsocks запущен."

# Дайте redsocks время на инициализацию
sleep 5

# Запуск ноды Rivalz
node index.js

# Удерживаем контейнер в активном состоянии
tail -f /dev/null
