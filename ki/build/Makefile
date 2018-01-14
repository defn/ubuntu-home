DATA = /data

all:
	mkdir -p .ssh
	rsync -ia ~/.ssh/authorized_keys .ssh/
	mkdir -p $(DATA)/script
	rsync -ia script/service $(DATA)/script/service
	docker build -t imma:ubuntu .
	docker-compose up -d
	sleep 5
	ssh -A -p 2222 ubuntu@127.0.0.1 /tmp/cache/script/bootstrap
