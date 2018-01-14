all:
	mkdir -p .ssh
	rsync -ia ~/.ssh/authorized_keys .ssh/
	mkdir -p /data/script
	rsync -ia script/service /data/script/service
	docker build -t imma:ubuntu .
	./docker-compose up
