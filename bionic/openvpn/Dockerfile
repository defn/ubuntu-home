FROM imma/ubuntu:bionic

RUN set -x \
  && apt-get install -y openvpn

EXPOSE 1194

COPY docker-entrypoint.sh /openvpn-entrypoint.sh
ENTRYPOINT ["/openvpn-entrypoint.sh"]
CMD ["ovpn_run"]
