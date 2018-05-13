all:
	docker-compose run -T --rm openvpn ovpn_genconfig -u udp://nat-adm3.immanent.io
	echo nat-adm3.immanent.io | docker-compose run -T --rm openvpn ovpn_initpki nopass
