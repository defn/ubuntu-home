build:
	docker build -t imma/ubuntu:dnsmasq .

test:
	@docker run -ti --network host --privileged imma/ubuntu:dnsmasq dnsmasq -d --log-facility=-
