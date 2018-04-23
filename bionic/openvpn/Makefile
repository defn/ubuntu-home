PROGRAM := $(shell basename $(shell pwd))

build:
	docker build -t imma/ubuntu:$(PROGRAM) .

shell:
	@docker run -ti imma/ubuntu:$(PROGRAM) bash

init:
	@docker run -v $(shell pwd)/config:/etc/openvpn imma/ubuntu:$(PROGRAM) ovpn_genconfig -u udp://localhost
	@echo localhost | docker run -i -v $(shell pwd)/config:/etc/openvpn imma/ubuntu:$(PROGRAM) ovpn_initpki nopass

test:
	@docker run -p 1194:1194/udp --cap-add=NET_ADMIN -v $(shell pwd)/config:/etc/openvpn imma/ubuntu:$(PROGRAM)

push:
	docker push imma/ubuntu:$(PROGRAM)
