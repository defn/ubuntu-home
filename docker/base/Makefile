SHELL := bash
REPO ?= imma/ubuntu
TAG ?= $(shell basename $(shell pwd))

CONTAINER_HOST := $(shell docker-compose ps -q $(TAG) 2>/dev/null).docker

all:
	$(MAKE) build up make tag down

build:
	docker build -t $(REPO):$(TAG)1 .

up:
	docker-compose down
	docker-compose up -d --build

make:
	$(MAKE) make_

make_:
	while true; do if ssh $(CONTAINER_HOST) ls -d /tmp/.done-$(TAG); then break; fi; sleep 1; done

tag:
	$(MAKE) tag_

tag_:
	docker commit $(shell basename $(CONTAINER_HOST) .docker) $(REPO):$(TAG)

down:
	docker-compose down
