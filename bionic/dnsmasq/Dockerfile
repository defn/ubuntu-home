FROM imma/ubuntu:bionic

RUN set -x \
  && apt-get update \
  && apt-get install -y dnsmasq

RUN rm -rf /var/lib/apt/lists/*

EXPOSE 53

COPY docker-entrypoint.sh /dnsmasq-entrypoint.sh
ENTRYPOINT ["/dnsmasq-entrypoint.sh"]
CMD ["dnsmasq"]
