FROM alpine:3.4

MAINTAINER Team Docksal, https://docksal.io

RUN apk add --update --no-cache \
	bash \
	curl \
	sudo \
	supervisor \
	openssl \
	nginx-lua \
	&& rm -rf /var/cache/apk/*

ENV DOCKER_VERSION 1.12.3
ENV DOCKER_GEN_VERSION 0.7.3

# Install docker client binary from Github (if not mounting binary from host)
RUN curl -sSL -O "https://get.docker.com/builds/$(uname -s)/$(uname -m)/docker-$DOCKER_VERSION.tgz" && \
	tar zxf docker-$DOCKER_VERSION.tgz && mv docker/docker /usr/local/bin && rm -rf docker-$DOCKER_VERSION* && \
	chmod +x /usr/local/bin/*

# Install docker-gen
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

COPY conf/crontab /var/spool/cron/crontabs/root
COPY bin/proxyctl /usr/local/bin/proxyctl
COPY bin/startup.sh /usr/local/bin/startup.sh

COPY www /var/www/proxy

# Stop inactive containers after timeout
ENV INACTIVITY_TIMEOUT 24h
# Disable debug output by default
ENV PROXY_DEBUG 0

ENTRYPOINT ["/usr/local/bin/startup.sh"]

CMD ["supervisord", "-n"]
