SHELL = bash

all: cidata.iso
	@true

cache:
	@rm -f .bashrc.cache
	@bash .bashrc
	@bash .bashrc

include $(BLOCK_PATH)/base/Makefile.docker

docker_default = docker-image

docker-image:
	time $(make) home=$(block) nc home

docker-update:
	time $(make) daemon $(pre_block) block-bootstrap $(after_block) commit
	time $(make) build
	$(make) clean

virtualbox:
	plane recycle
	plane vagrant ssh -- sudo aptitude update
	plane vagrant ssh -- ssh -o StrictHostKeyChecking=no git@github.com true 2>/dev/null || true
	time script/deploy plane vagrant ssh --
	time plane reuse

virtualbox-docker:
	plane recycle
	time plane vagrant ssh -- script/cloud-init-wait
	time plane vagrant ssh -- script/cloud-init-update
	time plane vagrant ssh -- script/cloud-init-bootstrap
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
	script/cibuild

add-modules:
	block list | awk '/\/work\// {print $$3, $$2}' | perl -pe 's{[^\s]+?/work/}{work/}' | runmany 1 2 'git submodule add -f -b master $$1 $$2'
