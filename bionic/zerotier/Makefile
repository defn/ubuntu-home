PROGRAM := $(shell basename $(shell pwd))

build:
	docker build -t imma/ubuntu:$(PROGRAM) .

shell:
	@docker run -ti imma/ubuntu:$(PROGRAM) bash

test:
	@docker run --device=/dev/net/tun --cap-add=NET_ADMIN --cap-add=SYS_ADMIN -v $(shell pwd)/config:/var/lib/zerotier-one imma/ubuntu:$(PROGRAM)

push:
	docker push imma/ubuntu:$(PROGRAM)
