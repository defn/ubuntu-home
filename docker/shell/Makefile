SHELL := bash
REPO ?= imma/ubuntu
TAG ?= $(shell basename $(shell pwd))

build:
	docker build --no-cache -t $(REPO):$(TAG) .
