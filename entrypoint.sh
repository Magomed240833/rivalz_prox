#!/bin/bash

# Проверяем, используется ли прокси
if [ -f /app/redsocks.conf ]; then
    echo "Starting redsocks..."
    redsocks -c /app/redsocks.conf &
    echo "Redsocks started."

    # Ждём, чтобы redsocks успел запуститься
    sleep 5

    echo "Configuring iptables..."
    iptables -t nat -A OUTPUT -p tcp --dport 80 -j REDIRECT --to-ports 12345
    iptables -t nat -A OUTPUT -p tcp --dport 443 -j REDIRECT --to-ports 12345
    echo "Iptables configured."
fi

# Запускаем Node.js-приложение
node index.js

# Поддерживаем контейнер активным
tail -f /dev/null
