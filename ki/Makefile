KI := conv
DATA ?= /data

all:
	mkdir -p .ssh
	rsync -ia ~/.ssh/authorized_keys .ssh/
	docker build -t imma:ubuntu .
	docker-compose up -d --force-recreate
	sleep 5
	ssh -A -p 2222 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@127.0.0.1 /tmp/cache/script/bootstrap

docker-macos:
	docker run -d -v /var/run/docker.sock:/var/run/docker.sock -p 127.0.0.1:2375:2375 bobrik/socat TCP-LISTEN:2375,fork UNIX-CONNECT:/var/run/docker.sock

docker:
	ki $(KI) docker-ubuntu

virtualbox:
	ki $(KI) virtualbox-ubuntu

virtualbox-docker:
	ki exec virtualbox-ubuntu -c 'ssh -A -o StrictHostKeyChecking=no ubuntu@localhost ki $(KI) docker-ubuntu'
