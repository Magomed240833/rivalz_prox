FROM node:18

# Установка необходимых пакетов
RUN apt-get update && apt-get install -y python3 make g++ redsocks iptables iproute2 && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# Копируем файлы
COPY entrypoint.sh ./
COPY index.js ./
COPY redsocks.conf /etc/redsocks.conf

# Устанавливаем зависимости и Rivalz Node CLI
RUN npm install node-pty && npm install -g rivalz-node-cli 
RUN chmod +x ./entrypoint.sh

# Установка правил iptables через redsocks
RUN iptables -t nat -A OUTPUT -p tcp --dport 80 -j REDIRECT --to-ports 12345 && \
    iptables -t nat -A OUTPUT -p tcp --dport 443 -j REDIRECT --to-ports 12345

ENTRYPOINT ["./entrypoint.sh"]
