# Sticking with alpine-3.4 as further versions do not have nginx-lua available
FROM alpine:3.4

RUN apk add --no-cache \
	bash \
	curl \
	sudo \
	supervisor \
	nginx-lua \
	&& rm -rf /var/cache/apk/*

ENV DOCKER_VERSION 17.06.0-ce
ENV DOCKER_GEN_VERSION 0.7.3

# Install docker client binary from Github (if not mounting binary from host)
RUN curl -sSL -O "https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz" \
	&& tar zxf docker-$DOCKER_VERSION.tgz && mv docker/docker /usr/local/bin && rm -rf docker-$DOCKER_VERSION*

# Install docker-gen
ENV DOCKER_GEN_TARFILE docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz
RUN curl -sSL https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/$DOCKER_GEN_TARFILE -O \
	&& tar -C /usr/local/bin -xvzf $DOCKER_GEN_TARFILE && rm $DOCKER_GEN_TARFILE

RUN chown -R nginx:nginx /var/lib/nginx

# Generate a self-signed cert
RUN apk add --no-cache openssl \
	&& openssl req -batch -x509 -newkey rsa:4086 -days 3650 -nodes -sha256 \
		-keyout /etc/nginx/server.key -out /etc/nginx/server.crt \
	&& apk del openssl

COPY conf/nginx/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx/default.conf.tmpl /etc/nginx/default.conf.tmpl
COPY conf/nginx/default_locations.conf /etc/nginx/default_locations.conf
COPY conf/sudoers /etc/sudoers
# Override the main supervisord config file, since some parameters are not overridable via an include
# See https://github.com/Supervisor/supervisor/issues/962
COPY conf/supervisord.conf /etc/supervisord.conf
COPY conf/crontab /var/spool/cron/crontabs/root
COPY bin /usr/local/bin
COPY www /var/www/proxy

# Fix permissions
RUN chmod 0440 /etc/sudoers

# Disable INACTIVITY_TIMEOUT by default
ENV PROJECT_INACTIVITY_TIMEOUT 0
# Disable DANGLING_TIMEOUT by default
ENV PROJECT_DANGLING_TIMEOUT 0
# Disable debug output by default
ENV PROXY_DEBUG 0

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["supervisord"]
