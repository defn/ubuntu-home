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
	sudo ln -nfs ubuntu/work/base ../base

include ../base/Makefile.docker

docker_default = docker-image

docker-image:
	time $(make) home=$(block) nc home

docker-update:
	docker tag $(registry)/block:$(block){0,}
	$(make) home=$(block) nc clean daemon
	time $(make) block-update $(after_block) commit
	$(make) clean

virtualbox:
	time plane recycle
	time script/deploy plane vagrant ssh --
	time plane reuse

virtualbox-docker:
	time plane recycle
	time plane vagrant ssh -- -A bash -c "$$(printf '%q' 'cd work/base && make docker')"
	time plane vagrant ssh -- -A bash -c "$$(printf '%q' 'script/update && make docker')"
	time plane reuse docker
