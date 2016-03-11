# docker-h2-server
Dockerfile for building docker container with passwordless sshd server and nginx serving static page. This is mostly a template for creating more useful docker images.

## About

This repository contains all needed resources to build a docker image with following features:
* sshd with passwordless login;
* nginx running and serving simple static page;
* h2 server and console running;
* services configured and runnign via supervisord.

if the image is run without mounting a host directory to /opt/h2-data then there will be no persistence. To enable persistence then just run the container as follows:
```
docker run -d -p 55522:22 -p 55580:80 -p 55581:81 -p 1521:1521 -v $(pwd)/t24-db:/opt/h2-data fxmartin/docker-h2-server
```

For convenience there is a *./manage.sh* command for building, starting (with proper port mappings), stopping and connecting via ssh.

## Usage

You can download [this image](https://hub.docker.com/r/fxmartin/docker-h2-server/) from public [Docker Registry](https://hub.docker.com/).
A bash script is provided: manage.sh, which allows to manage the container, considering that it won't stop by itself due to supervisor daemon:
* start: to start the container
* stop: to stop the container
* build: build the docker image
* ssh: ssh to the container
* web: launch chrome on port 80 from nginx, with the IP automatically retrieved from the script
* console: launch chrome on port 81 from h2 console, with the IP automatically retrieved from the script

**Run using command:**
```
docker run -d -p 55522:22 -p 55580:80 -p 55581:81 -p 1521:1521 fxmartin/ubuntu-h2-server
or
manage.sh start
```

**Connect via ssh:**
```
manage.sh ssh
```

## Notes
Just don't forget to add private key (yeah, I know) from **ssh_keys** folder to you '~/.ssh/' and add it via
```
ssh-add -K ~/.ssh/id_rsa_docker
```

## Sources
Forked from [viliusl/docker-h2-server](https://github.com/viliusl/docker-h2-server)
