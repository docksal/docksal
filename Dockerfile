FROM alpine:3.4

MAINTAINER Leonid Makarov <leonid.makarov@blinkreaction.com>

RUN apk add --update --no-cache \
	curl \
	sudo \
	supervisor \
	openssl \
	nginx-lua \
	&& rm -rf /var/cache/apk/*

ENV DOCKER_VERSION 1.12.1
ENV DOCKER_COMPOSE_VERSION 1.8.0
# Install docker client binary from Github (if not mounting binary from host)
RUN curl -L -O "https://get.docker.com/builds/$(uname -s)/$(uname -m)/docker-$DOCKER_VERSION.tgz" && \
	tar zxf docker-$DOCKER_VERSION.tgz && \
	sudo mv docker/* /usr/local/bin && \
	rm -rf docker-$DOCKER_VERSION*

# Install docker-compose using pip
# RUN apk add --update --no-cache py-pip \
# 	&& pip install docker-compose \
# 	&& rm -rf /var/cache/apk/*

# Install docker-compose binary from Github (if not mounting binary from host)
RUN curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose && \
	chmod +x /usr/local/bin/docker-compose

# Install docker-compose library dependencies (for the binary from Github)
# See https://github.com/docker/compose/pull/3856
RUN curl -L https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub && \
 	curl -L -O https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk && \
 	apk add --no-cache glibc-2.23-r3.apk && rm glibc-2.23-r3.apk && \
 	ln -s /lib/libz.so.1 /usr/glibc-compat/lib/ && \
 	ln -s /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib

# Install docker-gen
ENV DOCKER_GEN_VERSION 0.7.3
ENV DOCKER_GEN_TARFILE docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz
RUN curl -L https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/$DOCKER_GEN_TARFILE -O && \
	tar -C /usr/local/bin -xvzf $DOCKER_GEN_TARFILE && \
	rm $DOCKER_GEN_TARFILE

RUN chown -R nginx:nginx /var/lib/nginx

# Generate SSL certificate and key
RUN openssl req -batch -nodes -newkey rsa:2048 -keyout /etc/nginx/server.key -out /tmp/server.csr && \
    openssl x509 -req -days 365 -in /tmp/server.csr -signkey /etc/nginx/server.key -out /etc/nginx/server.crt; rm /tmp/server.csr

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/sudoers /etc/sudoers

RUN chmod 0440 /etc/sudoers

COPY conf/nginx.default.conf.tmpl /etc/nginx/default.conf.tmpl
COPY conf/supervisord.conf /etc/supervisor.d/docker-gen.ini

COPY bin/start_project.sh /usr/local/bin/start_project.sh

# Stop inactive containers.
ENV INACTIVITY_TIMEOUT 1h
COPY conf/crontab /var/spool/cron/crontabs/root
COPY bin/stop_projects.sh /usr/local/bin/stop_projects.sh

COPY www /var/www/proxy

ENV SUPERVISOR_DEBUG 0

CMD ["supervisord", "-n"]
