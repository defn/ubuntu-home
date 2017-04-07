ifeq (aws,$(firstword $(MAKECMDGOALS)))
KEYPAIR := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(KEYPAIR):;@:)
endif

ifeq (nih,$(firstword $(MAKECMDGOALS)))
VIP := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(VIP):;@:)
endif
VIP ?= 172.28.128.1

SHELL = bash

BLOCK_PATH ?= $(HOME)/work

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

docker-save:
	docker images | grep docker.nih  | perl -ne '@w = split /\s+/, $$_; print "$$w[0]:$$w[1]\n" unless $$base; $$base = 1 if $$w[1] eq "base"' | xargs docker save -o /data/cache/box/docker/inception.tar.1
	mv -f /data/cache/box/docker/inception.tar.1 /data/cache/box/docker/inception.tar

virtualbox:
	plane recycle
	plane vagrant ssh -- sudo aptitude update
	plane vagrant ssh -- ssh -o StrictHostKeyChecking=no git@github.com true 2>/dev/null || true
	time script/deploy plane vagrant ssh --
	cd $(BLOCK_PATH)/base && $(MAKE) clean-cidata
	cd $(BLOCK_PATH)/base && $(MAKE)
	time plane reuse

aws:
	env AWS_KEYPAIR=$(KEYPAIR) van recycle
	env AWS_KEYPAIR=$(KEYPAIR) van vagrant ssh -- sudo aptitude update
	time env AWS_KEYPAIR=$(KEYPAIR) script/deploy van vagrant ssh --
	time env AWS_KEYPAIR=$(KEYPAIR) van reuse

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

/config/ssh/authorized_keys:
	git clone git@github.com:imma/imma-config /config 2>/dev/null || true
	rsync -ia .ssh/authorized_keys /config/ssh/

nih: /config/ssh/authorized_keys
	script/configure
	$(MAKE) up
	script/configure
	$(MAKE) up

sync:
	git pull
	$(make) sync_fr

sync_fr:
	git submodule update --init
	cat Blockfile.lock  | envsubst | runmany 1 5 'set -x; cd $$2 && git checkout --force $$5 && git reset --hard $$4 || (cd $$2 && git fetch && git checkout --force $$5 && git reset --hard)'

update:
	$(make) sync
	home update

add-modules:
	block list | awk '/\/work\// {print $$3, $$2}' | perl -pe 's{[^\s]+?/work/}{work/}' | runmany 1 2 'git submodule add -f -b $(shell git rev-parse --abbrev-ref HEAD) $$1 $$2'

update-modules:
	block list | awk '/\/work\// {print $$3, $$2}' | perl -pe 's{[^\s]+?/work/}{work/}' | grep -v 'work/ubuntu' | runmany 1 2 'git update-index --cacheinfo 160000 $$(cd $(BLOCK_PATH)/../$$2 && git rev-parse HEAD) $$2'

$(BLOCK_PATH)/docs/Makefile.docs:
	git submodule update --init -j 10

lock:
	$(make) update-modules || true
	block lock
	git add -u work Blockfile.lock
	gs

include $(BLOCK_PATH)/docs/Makefile.docs
