PROGRAM := $(shell basename $(shell pwd))

build:
	docker build -t imma/ubuntu:$(PROGRAM) .

test:
	@docker run imma/ubuntu:$(PROGRAM)

push:
	docker push imma/ubuntu:$(PROGRAM)
