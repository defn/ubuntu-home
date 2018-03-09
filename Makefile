SHELL = bash

up:
	mkdir -p devshell/.ssh/
	rsync -ia .ssh/authorized_keys devshell/.ssh/
	docker-compose up -d --force-recreate --build
	$(MAKE) tx

tx:
	tx init $(shell docker-compose ps | grep _shell_ | awk '{print $$1}').docker

ssh:
	ssh -A $(shell docker-compose ps | grep _shell_ | awk '{print $$1}').docker

down:
	docker-compose down

update:
	docker-compose pull
	docker-compose build

bootstrap:
	true # what do we need

cache:
	source work/ubuntu-config/script/profile && source work/block/script/profile && require && block gen profile > .bashrc.cache.1
	mv -f .bashrc.cache.1 .bashrc.cache

sync:
	block sync fast
	$(MAKE) cache

update-modules:
	block list | awk '/\/work\// {print $$3, $$2}' | perl -pe 's{[^\s]+?/work/}{work/}' | grep -v 'work/ubuntu' | runmany 1 2 'git update-index --cacheinfo 160000 $$(cd $(BLOCK_PATH)/../$$2 && git rev-parse HEAD) $$2'

lock:
	$(MAKE) update-modules || true
	block lock
	git add -u work Blockfile.lock Blockfile.json
	git add .public content
	gs
