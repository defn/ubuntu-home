PROGRAM := $(shell basename $(shell pwd))

build:
	docker build -t imma/ubuntu:$(PROGRAM) .

test:
	@docker run imma/ubuntu:$(PROGRAM) uname -a

push:
	docker push imma/ubuntu:$(PROGRAM)
