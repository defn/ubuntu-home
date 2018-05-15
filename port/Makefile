build:
	runmany 'cd $$1 && make' bionic openvpn argo dnsmasq

ifeq (server,$(firstword $(MAKECMDGOALS)))
OPENVPN_SERVER := $(strip $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS)))
$(eval $(OPENVPN_SERVER):;@:)
endif

ifeq (client,$(firstword $(MAKECMDGOALS)))
OPENVPN_CLIENT := $(strip $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS)))
$(eval $(OPENVPN_CLIENT):;@:)
endif

ifeq (download,$(firstword $(MAKECMDGOALS)))
OPENVPN_CLIENT := $(strip $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS)))
$(eval $(OPENVPN_CLIENT):;@:)
endif

server:
	docker-compose run -T --rm openvpn ovpn_genconfig -u udp://$(OPENVPN_SERVER)
	echo $(OPENVPN_SERVER) | docker-compose run -T --rm openvpn ovpn_initpki nopass

client:
	docker-compose exec -T openvpn easyrsa build-client-full $(OPENVPN_CLIENT)
	$(MAKE) download $(OPENVPN_CLIENT)

download:
	docker-compose exec -T openvpn ovpn_getclient $(OPENVPN_CLIENT) | grep -v redirect-gateway | sudo tee config/$(OPENVPN_CLIENT).ovpn >/dev/null

restart:
	docker-compose down
	docker-compose up -d
	docker-compose logs -f
