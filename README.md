# Sensu Go Proof of Concept

Basic installation of Sensu Go to pit against Icinga 2 and other monitoring systems to help my DevOps team decide which monitoring platform to choose for real-time systems monitoring. 

## assumptions
- working Docker and Docker-compose installation
- "backend" Docker network setup using `docker network create sensu-backend`
- `/etc/hosts` entries similar to the following to map to running Docker containers:
    - 127.0.0.1 sensu.lab.test
- web browser proxy settings set to exclude `*.test` domain from using any wonky proxy servers

## initial installation
1. generate SSL certificates and keys
```bash
cd ssl/
make
cd ../
```
2. start Sensu Go backend
```bash
cd sensu-backend
mkdir data1 data2 data3
docker-compose up --build -d
cd ../
```
3. start HAproxy load balancer
```bash
cd sensu-load-balancer
docker-compose up --build -d
cd ../
```
4. start Sensu Go agents
```bash
for agent in sensu-agent sensu-agent-amazon-linux sensu-agent-centos sensu-agent-debian sensu-agent-ubuntu
do
    cd $agent
    docker-compose up --build -d
    cd ../
done
```
5. configure Sensuctl
```bash
mkdir -p ~/.config/sensu/sensuctl
ln -s sensuctl/cluster ~/.config/sensu/sensuctl/cluster
ln -s sensuctl/profile ~/.config/sensu/sensuctl/profile
```
6. change default agent user password
```
sensuctl user change-password agent --current-password P@ssw0rd! --new-password password123
```
7. load Sensu Go configurations such as assets, filters, handlers, etc.
```bash
cd sensu-backend/config/
for file in `find . -type f -name "*.yml" -or -name "*.yaml" -or -name "*.json"`; do sensuctl create --file $file --trusted-ca-file ../../ssl/ca/ca.pem; done
cd ../../
```
8. ensure Sensu Go cluster health is good
```bash
sensuctl cluster health --trusted-ca-file ./ssl/ca/ca.pem
```
9. ensure agents are checking into Sensu Go cluster
```bash
sensuctl entity list
```
