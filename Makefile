SHELL = bash

all: cidata.iso
	@true

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
	time $(make) build-nc
	$(make) clean

virtualbox:
	time plane recycle
	time script/deploy plane vagrant ssh --
	time plane reuse

virtualbox-docker:
	time plane recycle
	time plane vagrant ssh -- make download local
	time plane reuse docker

.ssh/ssh-container:
	@mkdir -p .ssh
	@ssh-keygen -f $@ -P '' -C "provision@$(shell uname -n)"

cidata/user-data: .ssh/ssh-container cidata/user-data.template
	mkdir -p cidata
	cat cidata/user-data.template | env CONTAINER_SSH_KEY="$(shell cat .ssh/ssh-container.pub)" envsubst '$$USER $$CONTAINER_SSH_KEY $$CACHE_VIP' | tee "$@.tmp"
	mv "$@.tmp" "$@"

cidata/meta-data:
	mkdir -p cidata
	echo --- | tee $@.tmp
	echo instance-id: $(shell basename $(shell pwd)) | tee -a $@.tmp
	mv $@.tmp $@

cidata.iso: cidata/user-data cidata/meta-data
	mkisofs -R -V cidata -o $@.tmp cidata
	mv $@.tmp $@

vagrant: cidata.iso
	vagrant up
	vagrant reload

nih:
	script/update
	sudo ifconfig lo:1 "172.28.128.1" up
	runmany 'cd work/$$1 && make up' admin nexus gogs
