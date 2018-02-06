-include env_make

VERSION ?= dev

REPO = docksal/vhost-proxy
NAME = docksal-vhost-proxy

.PHONY: build test push shell run start stop logs debug clean release

build:
	fin docker build -t $(REPO):$(VERSION) .

test:
	IMAGE=$(REPO):$(VERSION) bats tests/smoke-test.bats

push:
	fin docker push $(REPO):$(VERSION)

exec:
	fin docker exec -it $(NAME) $(CMD)

shell:
	make exec -e CMD=bash

start:
	fin system reset vhost-proxy

stop:
	fin docker stop $(NAME)

logs:
	fin docker logs $(NAME)

clean:
	fin docker rm -f $(NAME)

debug: build start
	fin docker logs -f $(NAME)

release: build
	make push -e VERSION=$(VERSION)

default: build
