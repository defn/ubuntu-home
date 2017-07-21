ifeq (nih,$(firstword $(MAKECMDGOALS)))
VIP := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(VIP):;@:)
endif
VIP ?= 172.28.128.1

SHELL = bash

BLOCK_PATH ?= $(HOME)/work

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

docker_host = $(shell aws ecr describe-repositories | jq -r --arg repo block '.repositories | map(select(.repositoryName == $$repo))[].repositoryUri' | cut -d/ -f1 2>/dev/null || true)

_base_home ?= $(HOME)/work/base

all:
	@true

cache:
	rm -f .bashrc.cache
	source work/block/script/profile && block gen profile > .bashrc.cache.1
	mv .bashrc.cache.1 .bashrc.cache

sync:
	block sync
	$(make) cache

include Makefile.build

docker_default = docker-image

aws_default = aws-image

update-modules:
	block list | awk '/\/work\// {print $$3, $$2}' | perl -pe 's{[^\s]+?/work/}{work/}' | grep -v 'work/ubuntu' | runmany 1 2 'git update-index --cacheinfo 160000 $$(cd $(BLOCK_PATH)/../$$2 && git rev-parse HEAD) $$2'

lock:
	$(make) update-modules || true
	block lock
	git add -u work Blockfile.lock
	gs

reset-docker:
	docker tag $(hub)/block:base $(registry)/$(image)

reset-docker-ubuntu:
	docker tag $(hub)/block:ubuntu $(registry)/$(image)

reset-virtualbox:
	vagrant box add -f block:ubuntu /data/cache/box/virtualbox/block-base.box

reset-aws:
	vagrant box add -f block:ubuntu /data/cache/box/aws/block-base.box

rebuild-docker:
	$(make) docker-update

docker-image:
	$(make) home=$(block) recycle home-update home-deploy image-update

home-deploy:
	script/deployx $(service_ssh_exec)

home-update:
	$(service_ssh_exec) -- sudo dpkg --configure -a
	$(service_ssh_exec) -- sudo apt-get update
	$(service_ssh_exec) -- sudo env DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

aws-image:
	env AWS_SYNC=/data/cache/packages/$(ID_INSTALL) $(make) home=$(block) aws-image-fr

aws-image-fast:
	env AWS_SYNC=/data/cache/packages/$(ID_INSTALL) $(make) home=$(block) aws-image-fr-fast

aws-continue:
	env AWS_SYNC=/data/cache/packages/$(ID_INSTALL) $(make) home=$(block) aws-continue-fr
	van reuse ubuntu

aws-image-fr:
	van recycle
	van vagrant ssh -- sudo sudo dpkg --configure -a
	van vagrant ssh -- sudo apt-get update
	$(make) aws-continue-fr
	van reuse ubuntu

aws-image-fr-fast:
	van recycle
	$(make) aws-continue-fr
	van export ubuntu
	vagrant destroy -f

aws-continue-fr:
	script/deployx van vagrant ssh --
	van vagrant ssh -- $(shell aws ecr get-login)
	van vagrant ssh -- script/deployx container $(shell echo $${GOLDEN_NAME#block-})

docker-update:
	$(make) recycle home-deploy block-finish minimize commit
	$(make) build
	$(make) clean

virtualbox:
	env $(make) virtualbox_fr

virtualbox_fr:
	cd $(_base_home) && make clean-cidata
	cd $(_base_home) && make >/dev/null
	plane recycle block:ubuntu
	plane vagrant ssh -- sudo sudo dpkg --configure -a
	plane vagrant ssh -- sudo apt-get update
	script/deployx plane vagrant ssh --
	cd $(_base_home) && make clean-cidata
	cd $(_base_home) && make >/dev/null
	plane reuse ubuntu

commit-virtualbox:
	cd $(_base_home) && make clean-cidata
	cd $(_base_home) && make >/dev/null
	plane reuse ubuntu

golden:
	$(MAKE) docker
	$(MAKE) upload
