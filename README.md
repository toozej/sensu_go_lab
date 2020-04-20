# Sensu Go Proof of Concept

Basic installation of Sensu Go to pit against Icinga 2 and other monitoring systems to help my DevOps team decide which monitoring platform to choose for real-time systems monitoring. 

## assumptions
- working Docker and Docker-compose installation
- `/etc/hosts` entries similar to the following to map to running Docker containers:
    - 127.0.0.1 sensu.lab.test
- web browser proxy settings set to exclude `*.test` domain from using any wonky proxy servers

## initial installation
```bash
sudo ./setuplab.sh
```

## stop lab after done with it
```bash
sudo ./stoplab.sh
```

## start lab after initial installation
```bash
sudo ./startlab.sh
```
