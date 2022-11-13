#!/bin/bash

# generate SSL certificates and keys
# skipping since already done in setuplab.sh

# start Sensu Go backend
cd sensu-backend
/usr/bin/docker compose up --build -d
cd ../
echo "waiting 10 seconds" && sleep 10

# start Grafana
cd grafana
/usr/bin/docker compose up --build -d
cd ../
echo "waiting 10 seconds" && sleep 10

# start HAproxy load balancer
cd sensu-load-balancer
/usr/bin/docker compose up --build -d
cd ../
echo "waiting 10 seconds" && sleep 10

# configure Sensuctl
# skipping since already done in setuplab.sh
sensuctl configure --non-interactive --username admin --password 'P@ssw0rd!' --trusted-ca-file "$(pwd)/ssl/ca/ca.pem"

# change default agent user password
# skipping since already done in setuplab.sh

# start Sensu Go (official) agent
cd sensu-agent
/usr/bin/docker compose up --build -d
cd ../

# start Sensu Go CentOS agents
cd sensu-agent-centos
/usr/bin/docker compose up --build -d
cd ../

# start Sensu Go Amazon Linux agents
cd sensu-agent-amazon-linux
/usr/bin/docker compose up --build -d
cd ../

# start Sensu Go Debian agents
cd sensu-agent-debian
/usr/bin/docker compose up --build -d
cd ../

# start Sensu Go Ubuntu agents
cd sensu-agent-ubuntu
/usr/bin/docker compose up --build -d
cd ../

# load Sensu Go assets
cd sensu-backend/config/assets
./load_assets.sh
cd ../../../

# load Sensu Go configurations such as filters, handlers, etc.
cd sensu-backend/config/
for file in `find . -type f -name "*.yml" -or -name "*.yaml" -or -name "*.json"`; do sensuctl create --file $file; done
cd ../../

# ensure Sensu Go cluster health is good
sensuctl cluster health

# ensure agents are checking into Sensu Go cluster
sensuctl entity list
