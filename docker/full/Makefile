SHELL := bash
REPO ?= imma/ubuntu
TAG ?= $(shell basename $(shell pwd))

build:
	docker build -m 2294967290 --memory-swap -1 --build-arg -t $(REPO):$(TAG) .
	rsync --progress -ia --blocking-io -e "docker run -i $(REPO):$(TAG)" env:/data/. data/.
