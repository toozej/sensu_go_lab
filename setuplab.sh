#!/bin/bash

# generate SSL certificates and keys
cd ssl/
make
cd ../

# create necessary docker networks
docker network create sensu-load-balancer
docker network create sensu-backend

# add hostfile entries if they doesn't already exist
for PROJECT in sensu grafana; do
    if ! grep -q "${PROJECT}.lab.test" /etc/hosts; then
        echo "127.0.0.1 ${PROJECT}.lab.test" | sudo tee -a /etc/hosts
    fi
done

# start Sensu Go backend
cd sensu-backend
rm -rf data1 data2 data3
mkdir data1 data2 data3
/usr/bin/docker compose up --build -d
cd ../
echo "waiting 10 seconds" && sleep 10

# start Grafana
cd grafana
mkdir data
chown -R 472:472 data/ config/ provisioning/
chmod 755 data/ config/ provisioning/
/usr/bin/docker compose up --build -d
cd ../
echo "waiting 10 seconds" && sleep 10

# start HAproxy load balancer
cd sensu-load-balancer
/usr/bin/docker compose up --build -d
cd ../
echo "waiting 10 seconds" && sleep 10

# configure Sensuctl
mkdir -p ~/.config/sensu/sensuctl
ln -fs "$(pwd)/sensuctl/cluster" ~/.config/sensu/sensuctl/cluster
ln -fs "$(pwd)/sensuctl/profile" ~/.config/sensu/sensuctl/profile
sensuctl configure --non-interactive --username admin --password 'P@ssw0rd!' --trusted-ca-file "$(pwd)/ssl/ca/ca.pem"

# change default agent user password
sensuctl user change-password agent --current-password P@ssw0rd! --new-password password123

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
