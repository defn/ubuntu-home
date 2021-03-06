SHELL = bash
TIMESTAMP = $(shell date +%s)

ifeq (init,$(firstword $(MAKECMDGOALS)))
TMUX_SESSION := $(strip $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS)))
$(eval $(TMUX_SESSION):;@:)
endif

ifeq (sync,$(firstword $(MAKECMDGOALS)))
TMUX_SESSION := $(strip $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS)))
$(eval $(TMUX_SESSION):;@:)
endif

ifeq (attach,$(firstword $(MAKECMDGOALS)))
TMUX_SESSION := $(strip $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS)))
$(eval $(TMUX_SESSION):;@:)
endif

ifeq (,$(TMUX_SESSION))
TMUX_SESSION = default
endif

test:
	drone exec

docker-vm:
	@docker run -it --privileged --pid=host imma/ubuntu:shell nsenter -t 1 -m -u -n -i sh || true

init:
	$(MAKE) up
	$(MAKE) sync
	$(MAKE) attach $(TMUX_SESSION)

build:
	docker-compose build --no-cache

ssh:
	ssh -A $(shell docker-compose ps -q shell).docker

sync:
	tx sync $(shell docker-compose ps -q shell).docker

attach:
	tx attach $(shell docker-compose ps -q shell).docker $(TMUX_SESSION)

up:
	$(MAKE) dummy
	mkdir -p b/.ssh/
	rsync -ia .ssh/authorized_keys b/.ssh/
	docker-compose down
	docker-compose up -d --force-recreate --build
	docker-compose exec shell ln -nfs /data /home/ubuntu 2>/dev/null || true
	docker inspect ubuntu_shell_1 | jq -r '.[] | .NetworkSettings.Networks.bridge.GlobalIPv6Address'

down:
	docker-compose down

cache:
	source script/rc && source work/block/script/profile && require && block gen profile > .bashrc.cache.1
	mv -f .bashrc.cache.1 .bashrc.cache

update-modules:
	block list | awk '/\/work\// {print $$3, $$2}' | perl -pe 's{[^\s]+?/work/}{work/}' | grep -v 'work/ubuntu' | runmany 1 2 'git update-index --cacheinfo 160000 $$(cd $(BLOCK_PATH)/../$$2 && git rev-parse HEAD) $$2'

lock:
	$(MAKE) update-modules || true
	block lock
	git add -u work Blockfile.lock Blockfile.json
	git add .public content
	gs

dummy:
	[[ "$(shell uname -s)" == "Darwin" ]] && sudo ifconfig lo0 alias 169.254.1.1 255.255.255.255 2>/dev/null || true

base: dummy
	runmany 'docker rmi -f imma/ubuntu:$$1 || true' base
	runmany 'docker system prune -f || true' 1 2 3
	mkdir -p docker/base/data/cache
	rsync -ia $(DATA)/cache/{packages,install,pyenv,rbenv,git} docker/base/data/cache/
	cd docker/base && $(MAKE)

base-update:
	block sync
	cd work/base && block bootstrap && block stale
	git clean -ffd
	git clean -ffd
	git clean -ffd

full: dummy
	rsync -ia docker/base/data/cache/. docker/full/data/cache/.
	cd docker/full && $(MAKE)

rebase: dummy
	cd docker/rebase && $(MAKE)

docs:
	mkdir -p content
	runmany 'cd $$1 && block compile docs' . work/{block,runmany}
	ln -nfs $(shell cd .public && ls -d ../work/*/.public/*/ | egrep -v '/(ubuntu|css|js)/') .public/
	block compile index

cidata/cidata.iso: cidata/user-data cidata/meta-data
	mkisofs -R -V cidata -o $@.tmp cidata
	mv $@.tmp $@

cidata/user-data: cidata/user-data.template
	cat "$<" | env CONTAINER_SSH_KEY="$(shell head -1 .ssh/authorized_keys)" envsubst '$$CONTAINER_SSH_KEY' | tee "$@.tmp"
	mv "$@.tmp" "$@"

cidata/meta-data: Makefile
	echo --- | tee $@.tmp
	echo instance-id: $(shell basename $(shell pwd))-$(shell date +%s) | tee -a $@.tmp
	mv $@.tmp $@
