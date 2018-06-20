PROGRAM := $(shell basename $(shell pwd))

build:
	docker build -t imma/ubuntu:$(PROGRAM) .

test:
	@docker run -p 3128:3128 imma/ubuntu:$(PROGRAM)

push:
	docker push imma/ubuntu:$(PROGRAM)
