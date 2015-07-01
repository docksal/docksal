FROM alpine:3.2

RUN apk add --update ca-certificates nginx supervisor && rm -rf /var/cache/apk/*

RUN mkdir -p /var/log/supervisor

ENV DOCKER_GEN_VERSION 0.3.9

RUN wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-i386-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-linux-i386-$DOCKER_GEN_VERSION.tar.gz \
 && rm /docker-gen-linux-i386-$DOCKER_GEN_VERSION.tar.gz

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf

COPY . /app/
WORKDIR /app/

ENV DOCKER_HOST unix:///tmp/docker.sock

CMD ["/usr/bin/supervisord"]
