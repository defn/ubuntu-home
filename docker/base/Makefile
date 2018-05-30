SHELL := bash
REPO ?= imma/ubuntu
TAG ?= $(shell basename $(shell pwd))

build:
	docker build --build-arg ECHO=echo -t $(REPO):$(TAG)1 .
	rsync --progress -ia --blocking-io -e "docker run -i $(REPO):$(TAG)1" env:/data/. data/.
	docker build --build-arg ECHO=env -t $(REPO):$(TAG) .
