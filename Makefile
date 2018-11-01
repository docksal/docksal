-include env_make

REPO = docksal/docksal
TAG = latest
NAME = docksal

.PHONY: build test push shell run start stop logs clean release

build:
	docker build -t $(REPO):$(TAG) .

test:
	IMAGE=$(REPO):$(TAG) NAME=$(NAME) tests/dind.bats

push:
	docker push $(REPO):$(TAG)

run:
	docker run --privileged --rm --name $(NAME) -it $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

start:
	clean
	docker run --privileged -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

exec:
	docker exec -u docker $(NAME) $(CMD)

shell:
	docker exec -u docker -it $(NAME) $(CMD)

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	docker rm -f $(NAME)

release: build
	make push -e TAG=$(TAG)

default: build
