#!/bin/sh

clear
echo "Join our discord https://discord.gg/aetherealco"
sleep 5

sudo apt-get update && sudo apt-get upgrade -y
sudo apt --fix-broken install -y
sudo apt-get autoremove -y
clear

echo "Chasm Scout Initial Configuration"
read -p "Enter Your Chasm Scout Name: " SCOUTNAME
read -p "Enter Your Scout UID: " SCOUTUID
read -p "Enter Your Webhook API Key: " WEBHOOKAPI
read -p "Enter the Groq API Key: " GROQAPI

echo "Installing required packages"
sudo apt-get install -y ca-certificates curl

echo "Setting up GPG keys and Docker repositories"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "Installing the Docker repository"
sudo sh -c "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable' > /etc/apt/sources.list.d/docker.list"

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Setting Chasm Initial Configuration"
mkdir -p ~/chasm
cd ~/chasm

cat > .env <<EOF
PORT=3001
LOGGER_LEVEL=debug
ORCHESTRATOR_URL=https://orchestrator.chasm.net
SCOUT_NAME=$SCOUTNAME
SCOUT_UID=$SCOUTUID
WEBHOOK_API_KEY=$WEBHOOKAPI
WEBHOOK_URL=http://$(hostname -I | awk '{print $1}'):3001/
PROVIDERS=groq
MODEL=gemma2-9b-it
GROQ_API_KEY=$GROQAPI
OPENROUTER_API_KEY=
OPENAI_API_KEY=
EOF

echo "Starting the chasm"
docker pull chasmtech/chasm-scout:latest
docker run -d --restart=always --env-file ./.env -p 3001:3001 --name scout chasmtech/chasm-scout
echo "Chasm Scout is running"

rm -- "$0"

echo "Chasm Scout setup completed successfully."
echo "Join our discord : https://discord.gg/aetherealco"