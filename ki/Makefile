KI := conv
DATA ?= /data

all: .kitchen/docker_id_rsa
	mkdir -p .ssh
	rsync -ia ~/.ssh/authorized_keys .ssh/
	docker build -t imma:ubuntu .
	docker-compose up -d --force-recreate
	while true; do if nc -z 127.0.0.1 2222; then break; fi; sleep 1; done
	while true; do if ssh -A -p 2222 -o IdentityFile=$(shell pwd)/.kitchen/docker_id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@127.0.0.1 true; then break; fi; sleep 1; done
	$(MAKE) continue
	docker commit ki_ubuntu_1 imma:latest
	docker-compose down || docker-compose down
	ki reset docker-imma
	(cd && make prune)

.kitchen/docker_id_rsa:
	mkdir -p .kitchen
	ssh-keygen -f .kitchen/docker_id_rsa -P ''

continue:
	ssh -A -p 2222 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@127.0.0.1 /tmp/cache/script/bootstrap

docker-listen:
	docker run -d -v /var/run/docker.sock:/var/run/docker.sock -p 2375:2375 bobrik/socat TCP-LISTEN:2375,fork UNIX-CONNECT:/var/run/docker.sock

docker:
	ki $(KI) docker-ubuntu

virtualbox:
	ki $(KI) virtualbox-ubuntu

virtualbox-docker:
	ki exec virtualbox-ubuntu -c 'ssh -A -o StrictHostKeyChecking=no ubuntu@localhost ki $(KI) docker-ubuntu'
