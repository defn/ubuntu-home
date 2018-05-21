SHELL := bash
REPO ?= imma/ubuntu
TAG ?= rebase

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
	while true; do if ssh $(CONTAINER_HOST) true; then break; fi; sleep 1; done
	ssh -A $(CONTAINER_HOST) /bootstrap

tag:
	$(MAKE) tag_

tag_:
	docker commit $(shell basename $(CONTAINER_HOST) .docker) $(REPO):$(TAG)
	docker commit $(shell basename $(CONTAINER_HOST) .docker) $(REPO):latest

down:
	docker-compose down
