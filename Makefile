SHELL = bash

all:
	@rm -f .bashrc.cache
	@script/cibuild ~
	@$(MAKE) cache

cache:
	@rm -f .bashrc.cache
	@bash .bashrc
	@bash .bashrc

subm:
	cat Blockfile.lock  | envsubst  | runmany 1 5 'echo git submodule add -f -b $$5 $$3 $${2/$$HOME\//}'

../base/Makefile.docker:
	sudo mkdir -p ../base
	sudo touch ../base/Makefile.docker

include ../base/Makefile.docker

docker-image:
	time $(MAKE) home=ubuntu-home home

docker-update:
	time $(MAKE) home=ubuntu-home clean daemon image-update

docker-bump:
	$(MAKE) bump
	git add .serial
	git commit -m "bump to $(shell cat .serial)"
	git push
	$(MAKE) docker-image
