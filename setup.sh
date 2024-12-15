#!/bin/bash

echo "Installing prerequisites..."
sudo apt update && sudo apt install -y docker.io docker-compose jq

echo "Configuring .env file..."
read -p "Enter WALLET_ADDRESS: " WALLET_ADDRESS
read -p "Enter number of CPU_CORES: " CPU_CORES
read -p "Enter RAM (e.g., 4G): " RAM
read -p "Enter DISK_SIZE (e.g., 10G): " DISK_SIZE

cat <<EOL > .env
WALLET_ADDRESS=${WALLET_ADDRESS}
CPU_CORES=${CPU_CORES}
RAM=${RAM}
DISK_SIZE=${DISK_SIZE}
DISK_SELECTION=""
EOL

echo "Do you want to configure a proxy? (Y/N)"
read -r use_proxy

if [[ "$use_proxy" =~ ^[Yy]$ ]]; then
    read -p "Enter proxy type (http/socks5): " proxy_type
    read -p "Enter proxy IP: " proxy_ip
    read -p "Enter proxy port: " proxy_port
    read -p "Enter proxy username (leave empty if not required): " proxy_username
    read -p "Enter proxy password (leave empty if not required): " proxy_password

    cat <<EOL > redsocks.conf
base {
    log_debug = off;
    log_info = on;
    log = "file:/var/log/redsocks.log";
    daemon = on;
    redirector = iptables;
}

redsocks {
    local_ip = 127.0.0.1;
    local_port = 12345;
    ip = $proxy_ip;
    port = $proxy_port;
    type = $proxy_type;
    login = "$proxy_username";
    password = "$proxy_password";
}
EOL
fi

echo "Building and starting Docker containers..."
docker-compose up -d --build
