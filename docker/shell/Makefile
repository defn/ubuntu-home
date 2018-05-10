SHELL := bash
REPO ?= imma/ubuntu
TAG ?= latest

CONTAINER_HOST := $(shell docker-compose ps -q shell 2>/dev/null).docker

all:
	$(MAKE) build up make tag down

build:
	docker build -t $(REPO):shell1 .

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
	docker commit $(shell basename $(CONTAINER_HOST) .docker) $(REPO):shell

down:
	docker-compose down
