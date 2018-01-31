KI := conv
DATA ?= /data
SSH_HOST ?= 127.0.0.1
REPO ?= imma
TAG ?= latest
PREFIX := fehfeh$(shell hostname | sed "s/-//g")

all:
	$(MAKE) base
	docker tag $(REPO):ubuntu $(REPO):start
	env COMPOSE_PROJECT_NAME=$(PREFIX) docker-compose up -d --force-recreate
	while true; do if nc -z $(SSH_HOST) 2222; then break; fi; sleep 1; done
	while true; do if ssh -A -p 2222 -o IdentityFile=$(shell pwd)/.kitchen/docker_id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@$(SSH_HOST) true; then break; fi; sleep 1; done
	$(MAKE) continue
	$(MAKE) finish
	docker tag $(REPO):latest $(REPO):start

base: .kitchen/docker_id_rsa
	(cd && make prune || true)
	mkdir -p .ssh
	rsync -ia ~/.ssh/authorized_keys .ssh/
	ln -nfs Dockerfile.base Dockerfile
	docker build -t $(REPO):ubuntu .

update:
	(cd && make prune || true)
	mkdir -p .ssh
	rsync -ia ~/.ssh/authorized_keys .ssh/
	ln -nfs Dockerfile.update Dockerfile
	docker build -t $(REPO):latest .
	env COMPOSE_PROJECT_NAME=$(PREFIX) docker-compose up -d --force-recreate
	while true; do if nc -z $(SSH_HOST) 2222; then break; fi; sleep 1; done
	while true; do if ssh -A -p 2222 -o IdentityFile=$(shell pwd)/.kitchen/docker_id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@$(SSH_HOST) true; then break; fi; sleep 1; done
	$(MAKE) continue
	$(MAKE) finish

continue:
	ssh -A -p 2222 -o IdentityFile=$(shell pwd)/.kitchen/docker_id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@$(SSH_HOST) /tmp/cache/script/bootstrap

finish:
	docker commit $(PREFIX)_$(REPO)_latest_1 $(REPO):latest
	env COMPOSE_PROJECT_NAME=$(PREFIX) docker-compose down || env COMPOSE_PROJECT_NAME=$(PREFIX) docker-compose down
	(cd && make prune >/dev/null 2>&1 || true)
	ki reset docker-$(REPO)

dind:
	$(MAKE) SSH_HOST=172.17.0.1

reset:
	$(MAKE) download
	ki reset docker-imma
	tx init docker-imma
	tx docker-imma

.kitchen/docker_id_rsa:
	mkdir -p .kitchen
	ssh-keygen -f .kitchen/docker_id_rsa -P ''

docker-listen:
	docker run -d -v /var/run/docker.sock:/var/run/docker.sock -p 2375:2375 bobrik/socat TCP-LISTEN:2375,fork UNIX-CONNECT:/var/run/docker.sock

tag:
	docker tag "$(REPO):$(TAG)" "$(shell aws ecr describe-repositories --repository-name $(REPO) | jq -r '.repositories[].repositoryUri'):$(TAG)"

upload:
	docker push "$(shell aws ecr describe-repositories --repository-name $(REPO) | jq -r '.repositories[].repositoryUri'):$(TAG)"

download:
	docker pull "$(shell aws ecr describe-repositories --repository-name $(REPO) | jq -r '.repositories[].repositoryUri'):$(TAG)"
	docker tag "$(shell aws ecr describe-repositories --repository-name $(REPO) | jq -r '.repositories[].repositoryUri'):$(TAG)" "$(REPO):$(TAG)"

docker:
	ki $(KI) docker-ubuntu

virtualbox:
	ki $(KI) virtualbox-ubuntu

virtualbox-docker:
	ki exec virtualbox-ubuntu -c 'ssh -A -o StrictHostKeyChecking=no ubuntu@localhost ki $(KI) docker-ubuntu'
