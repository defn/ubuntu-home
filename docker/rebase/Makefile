SHELL := bash
REPO ?= imma/ubuntu
TAG ?= latest

CONTAINER_HOST := $(shell docker-compose ps -q rebase 2>/dev/null).docker

all:
	sudo chgrp ubuntu /var/run/docker.sock 2>/dev/null || true
	$(MAKE) build up make tag down

build:
	docker create --name data -v data:/data alpine true 2>/dev/null || true
	docker build -t $(REPO):rebase1 .

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
	docker commit $(shell basename $(CONTAINER_HOST) .docker) $(REPO):latest

down:
	docker-compose down
