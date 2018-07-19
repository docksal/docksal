-include env_make

VERSION ?= dev

REPO = docksal/vhost-proxy
NAME = docksal-vhost-proxy

.PHONY: build test push shell run start stop logs debug clean release

build:
	docker build -t $(REPO):$(VERSION) .

test:
	IMAGE=$(REPO):$(VERSION) bats tests/smoke-test.bats

push:
	docker push $(REPO):$(VERSION)

exec:
	docker exec $(NAME) $(CMD)

exec-it:
	docker exec -it $(NAME) $(CMD)

shell:
	make exec -e CMD=bash

conf-vhosts:
	make exec -e CMD='cat /etc/nginx/conf.d/vhosts.conf'

# This is the only place where fin is used/necessary
start:
	IMAGE_VHOST_PROXY=$(REPO):$(VERSION) fin system reset vhost-proxy

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

logs-follow:
	docker logs -f $(NAME)

clean:
	docker rm -vf $(NAME)
	rm -rf projects

debug: build start logs-follow

release: build
	make push -e VERSION=$(VERSION)

# Curl command with http2 support via a docker container
# Usage: make curl -e ARGS='-kI https://docksal.io'
curl:
	docker run -t --rm badouralix/curl-http2 $(ARGS)

default: build
