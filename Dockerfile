FROM alpine:3.4

MAINTAINER Leonid Makarov <leonid.makarov@blinkreaction.com>

RUN apk add --update --no-cache \
	curl \
	sudo \
	supervisor \
	openssl \
	nginx-lua \
	&& rm -rf /var/cache/apk/*

# Install docker-compose using pip
# RUN apk add --update --no-cache py-pip \
# 	&& pip install docker-compose \
# 	&& rm -rf /var/cache/apk/*

# Install docker-compose binary from Github (if not mounting binary from host)
# RUN curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
# 	chmod +x /usr/local/bin/docker-compose

# Install docker-compose library dependencies (for the binary from Github)
# See https://github.com/docker/compose/pull/3856
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
 	wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk && \
 	apk add --no-cache glibc-2.23-r3.apk && rm glibc-2.23-r3.apk && \
 	ln -s /lib/libz.so.1 /usr/glibc-compat/lib/ && \
 	ln -s /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib

# Install docker-gen
ENV DOCKER_GEN_VERSION 0.7.3
ENV DOCKER_GEN_TARFILE docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz
RUN curl -sSL https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/$DOCKER_GEN_TARFILE -O && \
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

COPY www/refresh.html /var/www/proxy/refresh.html

ENV SUPERVISOR_DEBUG 0

CMD ["supervisord", "-n"]
