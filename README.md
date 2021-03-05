# Sensu Go Lab

Basic installation of Sensu Go for testing new versions, checks, assets, etc. 

## assumptions
- working Docker and Docker-compose installation
- `/etc/hosts` entries similar to the following to map to running Docker containers:
    - 127.0.0.1 sensu.lab.test
- web browser proxy settings set to exclude `*.test` domain from using any wonky proxy servers
- Sensu Go CLI (sensuctl) installed for your OS
    - See https://docs.sensu.io/sensu-go/latest/operations/deploy-sensu/install-sensu/#install-sensuctl for installation instructions

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
