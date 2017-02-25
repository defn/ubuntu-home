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

include $(BLOCK_PATH)/base/Makefile.docker

docker_default = docker-image

docker-image:
	time $(make) home=$(block) nc home

docker-update:
	$(make) home=$(block) nc clean daemon
	time $(make) block-update $(after_block) commit
	time $(make) build
	$(make) clean

virtualbox:
	plane recycle
	time plane vagrant ssh -- sudo aptitude update
	time script/deploy plane vagrant ssh --
	time plane reuse

virtualbox-docker:
	plane recycle
	time plane vagrant ssh -- script/cloud-init-bootstrap
	time plane vagrant ssh -- make nih
	#time plane reuse docker

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
	vagrant ssh -- make nih
	vagrant snapshot save nih

nih: cidata.iso
	script/update
	if ! ping -c 1 -t 3 172.28.128.1; then sudo ifconfig lo:1 "172.28.128.1" up; fi
	runmany 'cd work/$$1 && make up' admin nexus gogs
	sudo systemctl restart dnsmasq

upgrade:
	script/cloud-init-bootstrap
