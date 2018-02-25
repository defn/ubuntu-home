SHELL = bash

shell:
	mkdir -p build/.ssh/
	rsync -ia .ssh/authorized_keys build/.ssh/
	docker-compose build
	docker-compose up -d --force-recreate
	ssh -A $(shell docker-compose ps | grep _shell_ | awk '{print $$1}').docker

cache:
	source work/ubuntu-config/script/profile && source work/block/script/profile && require && block gen profile > .bashrc.cache.1
	mv -f .bashrc.cache.1 .bashrc.cache

sync:
	block sync fast
	$(make) cache
