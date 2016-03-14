#!/bin/bash
##############################################################################
# Script for managing docker image
# Based on manage.sh from https://github.com/fxmartin/docker-sshd-nginx
# Syncordis Copyright 2016
# Author: FX
# Date: 10-mar-2016
# Version: 1.10
##############################################################################

SCRIPT=manage.sh
VERSION=1.11

IMAGE="fxmartin/docker-h2-server"

ID=`docker ps | grep "$IMAGE" | head -n1 | cut -d " " -f1`
IP=`docker-machine ip docker`

BUILD_CMD="docker build -t=$IMAGE ."
RUN_CMD="docker run -d -p 55522:22 -p 55580:80 -p 55581:81  -p 55591:91 -p 1521:1521 $IMAGE"
SSH_CMD="ssh root@$IP -p 55522 -i ~/.ssh/id_rsa_docker"

is_running() {
	[ "$ID" ]
}

case "$1" in
        build)
                echo "Building Docker image: '$IMAGE'"
                $BUILD_CMD
                ;;
        start)
                if is_running; then
                	echo "Image '$IMAGE' is already running under Id: '$ID'"
                	exit 1;
                fi
                echo "Starting Docker image: '$IMAGE'"
                $RUN_CMD
                echo "Docker image: '$IMAGE' started"
                ;;

        stop)
                if is_running; then
					echo "Stopping Docker image: '$IMAGE' with Id: '$ID'"
	                docker stop "$ID"
					echo "Docker image: '$IMAGE' with Id: '$ID' stopped"

                else
                	echo "Image '$IMAGE' is not running"
                fi
                ;;

        status)
                if is_running; then
                	echo "Image '$IMAGE' is running under Id: '$ID'"
                else
                	echo "Image '$IMAGE' is not running"
                fi		
                ;;
        ssh)
                if is_running; then
                	echo "Attaching to running image '$IMAGE' with Id: '$ID'"
                	$SSH_CMD
                else
                	echo "Image '$IMAGE' is not running"
                fi		
                ;;
		web)
                open -a "Google Chrome" "http://$IP:55580"
                ;;
        console)
                open -a "Google Chrome" "http://$IP:55581"
                ;;
        proc)
                open -a "Google Chrome" "http://$IP:55591"
                ;;
        *)
                echo "Usage: $0 {build|start|stop|status|ssh|web|console}"
                exit 1
                ;;
esac

exit 0