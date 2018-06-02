SHELL := bash
REPO ?= imma/ubuntu
TAG ?= $(shell basename $(shell pwd))

build:
	docker build --build-arg ECHO=env -t $(REPO):$(TAG) .
	rsync --progress -ia --blocking-io -e "docker run -i $(REPO):$(TAG)" env:/data/. data/.
