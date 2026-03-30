#!/bin/bash

apt update -y
apt-get install net-tools zip curl jq tree unzip wget siege apt-transport-https ca-certificates software-properties-common gnupg lsb-release -y
curl -L https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/counting-service_linux_amd64.zip -o counting-service.zip
unzip counting-service.zip 
rm -rf counting-service.zip
mv counting-service_linux_amd64 counting-service
mv counting-service /usr/bin/counting-service
chmod 755 /usr/bin/counting-service
cat > /usr/lib/systemd/system/counting-api.service << 'EOF'

[Unit]
Description=counting API service
After=syslog.target network.target
    
[Service]
Environment=PORT="80"
ExecStart=/usr/bin/counting-service
User=root
Group=root
ExecStop=/bin/sleep 5
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
sleep 1
systemctl enable counting-api.service
systemctl start counting-api.service
sleep 1
systemctl status counting-api.service
lsof -i -P | grep counting