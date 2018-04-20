PROGRAM := $(shell basename $(shell pwd))

build:
	docker build -t imma/ubuntu:$(PROGRAM) .

shell:
	@docker run -ti imma/ubuntu:$(PROGRAM) bash

test:
	@docker run imma/ubuntu:$(PROGRAM)

push:
	docker push imma/ubuntu:$(PROGRAM)
