SHELL = bash

all:
	@rm -f .bashrc.cache
	@script/cibuild ~
	@$(MAKE) cache

cache:
	@rm -f .bashrc.cache
	@bash .bashrc
	@bash .bashrc


../base/Makefile.docker:
	sudo mkdir -p ../base
	sudo touch ../base/Makefile.docker

include ../base/Makefile.docker

docker-image:
	time $(MAKE) home=ubuntu-home home

docker-update:
	time $(MAKE) home=ubuntu-home clean daemon image-update
