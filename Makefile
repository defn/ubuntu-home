SHELL = bash

up:
	mkdir -p build/.ssh/
	rsync -ia .ssh/authorized_keys build/.ssh/
	docker-compose up -d --force-recreate
	ssh -A $(shell docker-compose ps | grep _shell_ | awk '{print $$1}').docker

down:
	docker-compose down

update:
	docker-compose pull
	docker-compose build

cache:
	source work/ubuntu-config/script/profile && source work/block/script/profile && require && block gen profile > .bashrc.cache.1
	mv -f .bashrc.cache.1 .bashrc.cache

sync:
	block sync fast
	$(make) cache
