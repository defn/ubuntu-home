SHELL = bash

all: cidata.iso
	@true

cache:
	 rm -f .bashrc.cache
	@bash .bashrc
	@bash .bashrc

include $(BLOCK_PATH)/base/Makefile.docker

docker_default = docker-image

docker-image:
	time $(make) home=$(block) nc home

docker-update:
	time $(make) daemon $(pre_block) block-finish $(after_block) commit
	time $(make) build
	$(make) clean

virtualbox:
	plane recycle
	plane vagrant ssh -- sudo aptitude update
	plane vagrant ssh -- ssh -o StrictHostKeyChecking=no git@github.com true 2>/dev/null || true
	time script/deploy plane vagrant ssh --
	time plane reuse

aws:
	van recycle
	van vagrant ssh -- sudo aptitude update
	time script/deploy van vagrant ssh --
	time van reuse

cidata/user-data: /config/ssh/authorized_keys cidata/user-data.template
	mkdir -p cidata
	cat cidata/user-data.template | envsubst '$$USER $$CACHE_VIP' | tee "$@.tmp"
	mv "$@.tmp" "$@"

cidata/meta-data:
	mkdir -p cidata
	echo --- | tee $@.tmp
	echo instance-id: $(shell basename $(shell pwd)) | tee -a $@.tmp
	mv $@.tmp $@

cidata.iso: cidata/user-data cidata/meta-data
	mkisofs -R -V cidata -o $@.tmp cidata
	mv $@.tmp $@

vagrant:
	vagrant up
	vagrant reload
	vagrant ssh -- make nih
	vagrant snapshot save nih

nih:
	script/update
	@echo 'server=/consul/127.0.0.1#5354' | sudo tee /etc/dnsmasq.d/nih
	@echo 'address=/nih/172.28.128.1' | sudo tee -a /etc/dnsmasq.d/nih
	@echo 'server=8.8.4.4' | sudo tee -a /etc/dnsmasq.d/nih
	sudo systemctl restart dnsmasq
	@echo 'DOCKER_OPTS="--dns 172.28.128.1"' | sudo tee /etc/default/docker
	sudo systemctl restart docker
	touch .gitconfig

sync:
	git pull
	$(make) sync_fr

sync_fr:
	git submodule update --init
	git submodule foreach git checkout master
	git submodule foreach git reset --hard origin/master

update:
	$(make) sync
	home update

upgrade:
	script/cibuild

add-modules:
	block list | awk '/\/work\// {print $$3, $$2}' | perl -pe 's{[^\s]+?/work/}{work/}' | runmany 1 2 'git submodule add -f -b master $$1 $$2'

$(BLOCK_PATH)/docs/Makefile.docs:
	git submodule update --init -j 10

include $(BLOCK_PATH)/docs/Makefile.docs
