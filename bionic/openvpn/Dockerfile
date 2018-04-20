FROM imma/ubuntu:bionic

RUN set -x \
  && apt-get update \
  && apt-get install -y openvpn

RUN rm -rf /var/lib/apt/lists/*

EXPOSE 1194

COPY docker-entrypoint.sh /openvpn-entrypoint.sh
ENTRYPOINT ["/openvpn-entrypoint.sh"]
CMD ["ovpn_run"]
