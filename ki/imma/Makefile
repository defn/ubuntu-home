up:
	docker-compose up

connect:
	block openvpn script/server default $(shell pwd)/docker-for-mac.ovpn

ssh_host := $(shell docker inspect imma_latest_1 2>/dev/null | jq -r '.[0].NetworkSettings.Networks.imma_default.IPAddress') $(opt)

ssh:
	mkdir -p .ssh
	ssh-keyscan $(ssh_host) > .ssh/known_hosts
	ssh -A -o StrictHostKeyChecking=yes -o UserKnownHostsFile=.ssh/known_hosts $(ssh_host) $(opt)
