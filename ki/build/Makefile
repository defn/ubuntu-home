all:
	mkdir -p .ssh
	rsync -ia ~/.ssh/authorized_keys .ssh/
	docker build -t imma:ubuntu .
