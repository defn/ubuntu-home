KI := conv
DATA ?= /data
SSH_HOST ?= 127.0.0.1

PREFIX := fehfeh-$(shell hostname)

all: .kitchen/docker_id_rsa
	(cd && make prune || true)
	mkdir -p .ssh
	rsync -ia ~/.ssh/authorized_keys .ssh/
	docker build -t imma:ubuntu .
	env COMPOSE_PROJECT_NAME=$(PREFIX) docker-compose up -d --force-recreate
	while true; do if nc -z $(SSH_HOST) 2222; then break; fi; sleep 1; done
	while true; do if ssh -A -p 2222 -o IdentityFile=$(shell pwd)/.kitchen/docker_id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@$(SSH_HOST) true; then break; fi; sleep 1; done
	$(MAKE) continue
	docker commit $(PREFIX)_imma_latest_1 imma:latest
	env COMPOSE_PROJECT_NAME=$(PREFIX) docker-compose down || env COMPOSE_PROJECT_NAME=$(PREFIX) docker-compose down
	(cd && make prune >/dev/null 2>&1 || true)
	ki reset docker-imma

.kitchen/docker_id_rsa:
	mkdir -p .kitchen
	ssh-keygen -f .kitchen/docker_id_rsa -P ''

continue:
	ssh -A -p 2222 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@$(SSH_HOST) /tmp/cache/script/bootstrap

docker-listen:
	docker run -d -v /var/run/docker.sock:/var/run/docker.sock -p 2375:2375 bobrik/socat TCP-LISTEN:2375,fork UNIX-CONNECT:/var/run/docker.sock

TAG ?= ubuntu

tag:
	docker tag "imma:$(TAG)" "$(shell aws ecr describe-repositories --repository-name imma | jq -r '.repositories[].repositoryUri'):$(TAG)"

upload:
	docker push "$(shell aws ecr describe-repositories --repository-name imma | jq -r '.repositories[].repositoryUri'):$(TAG)"

download:
	docker pull "$(shell aws ecr describe-repositories --repository-name imma | jq -r '.repositories[].repositoryUri'):$(TAG)"
	docker tag "$(shell aws ecr describe-repositories --repository-name imma | jq -r '.repositories[].repositoryUri'):$(TAG)" "imma:$(TAG)"

docker:
	ki $(KI) docker-ubuntu

virtualbox:
	ki $(KI) virtualbox-ubuntu

virtualbox-docker:
	ki exec virtualbox-ubuntu -c 'ssh -A -o StrictHostKeyChecking=no ubuntu@localhost ki $(KI) docker-ubuntu'
