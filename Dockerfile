FROM alpine:3.3

RUN apk add --update \
	ca-certificates \
	supervisor \
	nginx \

	&& rm -rf /var/cache/apk/*

RUN chown -R nginx:nginx /var/lib/nginx

# Generate SSL certificate and key
RUN openssl req -batch -nodes -newkey rsa:2048 -keyout /etc/nginx/server.key -out /tmp/server.csr && \
    openssl x509 -req -days 365 -in /tmp/server.csr -signkey /etc/nginx/server.key -out /etc/nginx/server.crt; rm /tmp/server.csr

ENV DOCKER_GEN_VERSION 0.7.3
ENV DOCKER_GEN_TARFILE docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

RUN wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/$DOCKER_GEN_TARFILE && \
	tar -C /usr/local/bin -xvzf $DOCKER_GEN_TARFILE && \
	rm $DOCKER_GEN_TARFILE

ENV DOCKER_HOST unix:///tmp/docker.sock

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx.default.conf.tmpl /etc/nginx/default.conf.tmpl
COPY conf/supervisord.conf /etc/supervisor.d/docker-gen.ini

CMD ["supervisord", "-n"]
