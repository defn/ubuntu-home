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

sync:
	git pull
	$(make) sync_fr

sync_fr:
	cd /config && git pull
	git submodule update --init
	cat Blockfile.lock  | envsubst | runmany 1 5 'set -x; cd $$2 && git checkout --force $$5 && git reset --hard $$4 || (cd $$2 && git fetch && git checkout --force $$5 && git reset --hard)'
	$(make) cache

include $(BLOCK_PATH)/base/Makefile.docker

docker_default = docker-image

docker-image:
	time $(make) home=$(block) daemon home-deploy image-update

docker-update:
	time $(make) daemon home-deploy block-finish minimize commit
	time $(make) build
	$(make) clean

docker-save:
	mkdir -p /data/cache/box/docker
	docker images | grep docker.nih  | perl -ne '@w = split /\s+/, $$_; print "$$w[0]:$$w[1]\n" unless $$base; $$base = 1 if $$w[1] eq "base"' | xargs docker save -o /data/cache/box/docker/inception.tar.1
	mv -f /data/cache/box/docker/inception.tar.1 /data/cache/box/docker/inception.tar

virtualbox:
	plane recycle
	plane vagrant ssh -- sudo aptitude update
	time script/deploy plane vagrant ssh --
	time plane reuse

virtualbox-docker:
	plane recycle
	plane vagrant ssh -- make docker-ubuntu
	time plane reuse docker

aws:
	van recycle
	van vagrant ssh -- sudo aptitude update
	time script/deploy van vagrant ssh --
	time van reuse

aws-docker:
	van recycle
	van vagrant ssh -- make docker-ubuntu
	time van reuse docker

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

reset:
	docker tag $(registry)/block:base $(registry)/$(image)

reset-virtualbox:
	vagrant box add -f inception /data/cache/box/virtualbox/inception-packer.box

reset-aws:
	vagrant box add -f inception /data/cache/box/aws/inception-packer.box

docker-ubuntu:
	$(make) sync
	$(make) docker-ubuntu-fr

docker-ubuntu-fr:
	script/configure
	runmany 'cd $1 && make reset && make nc docker' ~/work/base ~
	script/unconfigure
	$(make) prune
	sync
