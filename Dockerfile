##############################################################################
# Dockerfile project for building a mix container with h2 database and web
# console. Source image https://github.com/fxmartin/docker-sshd-nginx provides
# nginx and sshd as well.
#
# Build with docker build -t fxmartin/docker-h2-server .
#
# Syncordis Copyright 2016
# Author: FX
# Date: 09-mar-2016
# Version: 1.0
##############################################################################

FROM fxmartin/docker-sshd-nginx

# Maintainer details
MAINTAINER fxmartin <fxmartin@syncordisconsulting.com>

# install java
RUN apt-get update && apt-get install -y \
	openjdk-7-jre-headless \
	unzip \
	wget  && \
	apt-get autoremove && apt-get autoclean && apt-get clean -y

# set-up h2
RUN wget http://www.h2database.com/h2-2014-04-05.zip && \
	unzip h2-2014-04-05.zip -d /opt/ && \
	rm h2-2014-04-05.zip
ADD h2/h2-server.sh /opt/h2/bin/h2-server.sh
ADD h2/TAFJFunctions.jar /opt/h2/bin/TAFJFunctions.jar
RUN chmod +x /opt/h2/bin/h2-server.sh
ADD h2/h2-conf /opt/h2-conf
RUN mkdir -p /opt/h2-data

# update nginx
ADD nginx/index.html        /var/www/index.html

# configure supervisor
ADD supervisor/h2.conf   		/etc/supervisor/conf.d/h2.conf

#h2 tcp, nginx, h2 console, sshd
EXPOSE 1521 80 81 22 91

CMD ["/usr/bin/supervisord", "-n"]