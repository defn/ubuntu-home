SHELL = bash

all:
	@rm -f .bashrc.cache
	@script/cibuild ~
	@$(MAKE) cache

cache:
	@rm -f .bashrc.cache
	@bash .bashrc
	@bash .bashrc

latest:
	git pull
	block clone
	home update
	cat Blockfile.lock  | envsubst  | runmany 1 5 'git submodule add -f -b $$5 $$3 $${2/$$HOME\//} || true'
	git add -u 
	home lock 'update to latest modules'

../base/Makefile.docker:
	sudo mkdir -p ../base
	sudo touch ../base/Makefile.docker

include ../base/Makefile.docker

docker_default = docker-image

docker-image:
	time $(make) home=$(block) nc home

docker-update:
	docker tag $(registry)/block:$(block){0,}
	$(make) home=$(block) nc clean daemon
	time $(make) block-update $(after_block) commit
	$(make) clean

docker-bump:
	$(make) bump
	git add .serial
	git commit -m "bump to $(shell cat .serial)"
	git push
	$(make) docker-image
