SHELL = bash
TIMESTAMP = $(shell date +%s)

ifeq (tx-init,$(firstword $(MAKECMDGOALS)))
TMUX_SESSION := $(strip $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS)))
$(eval $(TMUX_SESSION):;@:)
endif

ifeq (init,$(firstword $(MAKECMDGOALS)))
TMUX_SESSION := $(strip $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS)))
$(eval $(TMUX_SESSION):;@:)
endif

ifeq (tx,$(firstword $(MAKECMDGOALS)))
TMUX_SESSION := $(strip $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS)))
$(eval $(TMUX_SESSION):;@:)
endif

ifeq (,$(TMUX_SESSION))
TMUX_SESSION = default
endif

ifeq (base,$(firstword $(MAKECMDGOALS)))
UBUNTU_TAG := $(strip $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS)))
$(eval $(UBUNTU_TAG):;@:)
endif

ifeq (,$(UBUNTU_TAG))
UBUNTU_TAG = base
endif

test:
	drone exec

ssh:
	@docker run -ti --rm -u ubuntu -w /home/ubuntu -v $(DATA):/data -v /var/run/docker.sock:/var/run/docker.sock imma/ubuntu:$(UBUNTU_TAG) || true

docker-vm:
	@docker run -it --privileged --pid=host imma/ubuntu:shell nsenter -t 1 -m -u -n -i sh || true

init:
	$(MAKE) up
	$(MAKE) tx-init $(TMUX_SESSION)

up:
	mkdir -p b/devshell/.ssh/
	rsync -ia .ssh/authorized_keys b/devshell/.ssh/
	docker-compose down
	docker-compose up -d --force-recreate --build
	docker inspect ubuntu_shell_1 | jq -r '.[] | .NetworkSettings.Networks.bridge.GlobalIPv6Address'

tx-init:
	tx init $(shell docker-compose ps -q shell).docker $(TMUX_SESSION)

tx:
	tx $(shell docker-compose ps -q shell).docker $(TMUX_SESSION)

down:
	docker-compose down

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

dummy:
	[[ "$(shell uname -s)" == "Darwin" ]] && sudo ifconfig lo0 alias 169.254.1.1 255.255.255.255 2>/dev/null || true

shell: dummy
	cd docker/shell && env COMPOSE_PROJECT_NAME=$(TIMESTAMP) $(MAKE)

base: dummy
	runmany 'docker rmi -f imma/ubuntu:$$1 || true' base latest rebase1 full1 base1
	runmany 'docker system prune -f || true' 1 2 3
	rm -f $(DATA)/cache/git/$(PKGSRC_BRANCH).tar.gz
	cd docker/base && $(MAKE)

base-update:
	block sync
	cd work/base && block bootstrap && block stale

full: dummy
	cd docker/full && env COMPOSE_PROJECT_NAME=$(TIMESTAMP) $(MAKE)

rebase: dummy
	cd docker/rebase && env COMPOSE_PROJECT_NAME=$(TIMESTAMP) $(MAKE)

push:
	runmany 'docker push imma/ubuntu:$$1' shell base full latest

pull:
	runmany 'docker pull imma/ubuntu:$$1' shell base full latest

docs:
	mkdir -p content
	runmany 'cd $$1 && block compile docs' . work/{block,runmany}
	ln -nfs $(shell cd .public && ls -d ../work/*/.public/*/ | egrep -v '/(ubuntu|css|js)/') .public/
	block compile index
