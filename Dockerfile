# Используем базовый образ Ubuntu для гибкости
FROM ubuntu:latest

# Отключаем интерактивный режим при установке пакетов
ENV DEBIAN_FRONTEND=noninteractive

# Устанавливаем необходимые системные зависимости
RUN apt-get update && apt-get install -y \
    curl \
    redsocks \
    iptables \
    iproute2 \
    jq \
    nano \
    nodejs \
    npm \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем глобально rivalz-node-cli
RUN npm install -g rivalz-node-cli

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем все файлы из локальной папки в контейнер
COPY . .

# Делаем entrypoint.sh исполняемым
RUN chmod +x entrypoint.sh

# Указываем точку входа
ENTRYPOINT ["./entrypoint.sh"]

