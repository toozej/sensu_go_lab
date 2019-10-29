# Sensu Go Proof of Concept

Basic installation of Sensu Go to pit against Icinga 2 and other monitoring systems to help my DevOps team decide which monitoring platform to choose for real-time systems monitoring. 

## assumptions
- working Docker and Docker-compose installation
- "backend" Docker network setup using `docker network create sensu-backend`
- Traefik v1.x Docker-Compose project installed and running (see https://github.com/toozej/mobile_homelab/tree/9642c52acb731ca2f03a0af385b3e74c1df6f346/traefik for configuration used to support this POC)
- `/etc/hosts` entries similar to the following to map to running Docker containers:
    - 127.0.0.1 traefik.lab.test
    - 127.0.0.1 sensu.lab.test
- web browser proxy settings set to exclude `*.test` domain from using any wonky proxy servers
