FROM imma/ubuntu:bionic

RUN set -x \
  && apt-get install -y dnsmasq

EXPOSE 53

COPY docker-entrypoint.sh /dnsmasq-entrypoint.sh
ENTRYPOINT ["/dnsmasq-entrypoint.sh"]
CMD ["dnsmasq", "-d", "--no-resolv", "--log-facility=-"]
