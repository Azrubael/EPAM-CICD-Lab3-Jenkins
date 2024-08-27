# cicd-pipeline 2024-08-27
==========================
with Jenkins version 2.462.1

[0] - Prerequizites:
    - Lunix Ubuntu 18.04 or newer;
    - Oracle VirtualBox 6.5 or newer;
    - Vagrant 2.4.1 or newer

[1] - Run two virtual machines:
```bash
vagrant up
```

[2] - Run Jenkins Web interface:
http://192.168.56.20:8080


[3] - Check if the containers are working.
    On BuiltIn node:
http://192.168.56.20:3000
http://192.168.56.20:3001
    On SILVER node:
http://192.168.56.18:3000
http://192.168.56.18:3001


[4] - Pull and run containers manually:
```bash
docker run --detach --rm \
    --name app-main-container \
    --publish 3000:3000 \
    azrubael/nodemain:v1.0
docker run --detach --rm \
    --name app-dev-container \
    --publish 3001:3000 \
    azrubael/nodedev:v1.0
```