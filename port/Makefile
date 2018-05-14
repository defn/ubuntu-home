build:
	runmany 'cd $$1 && make' bionic openvpn argo dnsmasq

ifeq (openvpn-config,$(firstword $(MAKECMDGOALS)))
OPENVPN_HOSTNAME := $(strip $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS)))
$(eval $(OPENVPN_HOSTNAME):;@:)
endif

openvpn-config:
	docker-compose run -T --rm openvpn ovpn_genconfig -u udp://$(OPENVPN_HOSTNAME)
	echo $(OPENVPN_HOSTNAME) | docker-compose run -T --rm openvpn ovpn_initpki nopass
