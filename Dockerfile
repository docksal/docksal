FROM openresty/openresty:1.13.6.2-1-alpine

RUN set -xe; \
	apk add --update --no-cache \
		bash \
		curl \
		sudo \
		supervisor \
	; \
	rm -rf /var/cache/apk/*

RUN set -xe; \
	addgroup -S nginx; \
	adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx

ARG DOCKER_VERSION=18.06.1-ce
ARG DOCKER_GEN_VERSION=0.7.4
ARG GOMPLATE_VERSION=3.0.0

# Install docker client binary (if not mounting binary from host)
RUN set -xe; \
	curl -sSL -O "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz"; \
	tar zxf docker-$DOCKER_VERSION.tgz; \
	mv docker/docker /usr/local/bin ; \
	rm -rf docker*

# Install docker-gen
ARG DOCKER_GEN_TARFILE=docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz
RUN set -xe; \
	curl -sSL -O "https://github.com/jwilder/docker-gen/releases/download/${DOCKER_GEN_VERSION}/${DOCKER_GEN_TARFILE}"; \
	tar -C /usr/local/bin -xvzf $DOCKER_GEN_TARFILE; \
	rm $DOCKER_GEN_TARFILE

# Install gomplate
RUN set -xe; \
	curl -sSL https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-amd64-slim -o /usr/local/bin/gomplate; \
	chmod +x /usr/local/bin/gomplate

# Symlink openresety config folder to /etc/nginx to preserver full compatibility with original nginx setup
RUN set -xe; \
	rm -rf /etc/nginx && ln -s /usr/local/openresty/nginx/conf /etc/nginx ; \
	mkdir -p /etc/nginx/conf.d

# Certs
RUN set -xe; \
	apk add --update --no-cache \
		openssl \
	; \
	# Create a folder for custom vhost certs (mount custom certs here)
	mkdir -p /etc/certs/custom; \
	# Generate a self-signed fallback cert
	openssl req \
		-batch \
		-newkey rsa:4086 \
		-x509 \
		-nodes \
		-sha256 \
		-subj "/CN=*.docksal" \
		-days 3650 \
		-out /etc/certs/server.crt \
		-keyout /etc/certs/server.key; \
	apk del openssl && rm -rf /var/cache/apk/*;

COPY conf/nginx/ /etc/nginx/
COPY conf/sudoers /etc/sudoers
# Override the main supervisord config file, since some parameters are not overridable via an include
# See https://github.com/Supervisor/supervisor/issues/962
COPY conf/supervisord.conf /etc/supervisord.conf
COPY conf/crontab /var/spool/cron/crontabs/root
COPY bin /usr/local/bin
COPY www /var/www/proxy

# Fix permissions
RUN chmod 0440 /etc/sudoers

ENV \
	# Disable INACTIVITY_TIMEOUT by default
	PROJECT_INACTIVITY_TIMEOUT=0 \
	# Disable DANGLING_TIMEOUT by default
	PROJECT_DANGLING_TIMEOUT=0 \
	# Disable access log by default
	ACCESS_LOG=0 \
	# Disable debug output by default
	DEBUG_LOG=0 \
	# Disable stats log by default
	STATS_LOG=0 \
	# Default domain
	DEFAULT_CERT=docksal

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["supervisord"]
