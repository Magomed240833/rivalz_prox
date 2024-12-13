FROM node:18

RUN apt-get update && apt-get install -y python3 make g++ proxychains && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY entrypoint.sh ./
COPY index.js ./

RUN npm install node-pty && npm install -g rivalz-node-cli 
RUN chmod +x ./entrypoint.sh

# Настройка proxychains
COPY proxychains.conf /etc/proxychains.conf

ENTRYPOINT ["./entrypoint.sh"]
