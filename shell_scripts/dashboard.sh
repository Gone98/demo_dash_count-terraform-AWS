#!/bin/bash

apt update -y
apt-get install net-tools zip curl jq tree unzip wget siege apt-transport-https ca-certificates software-properties-common gnupg lsb-release -y
curl -L https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/dashboard-service_linux_amd64.zip -o dashboard-service.zip
unzip dashboard-service.zip 
rm -rf dashboard-service.zip
mv dashboard-service_linux_amd64 dashboard-service
mv dashboard-service /usr/bin/dashboard-service
chmod 755 /usr/bin/dashboard-service
cat > /usr/lib/systemd/system/dashboard-api.service << 'EOF'

[Unit]
Description=Dashboard API service
After=syslog.target network.target
    
[Service]
Environment=PORT="80"
Environment=COUNTING_SERVICE_URL="http://10.0.0.200:80"
ExecStart=/usr/bin/dashboard-service
User=root
Group=root
ExecStop=/bin/sleep 5
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
sleep 1
systemctl enable dashboard-api.service
systemctl start dashboard-api.service
sleep 1
systemctl status dashboard-api.service
lsof -i -P | grep dashboard