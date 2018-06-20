FROM imma/ubuntu:bionic

RUN set -x \
  && apt-get update && apt-get install -y squid3

RUN cp /etc/squid/squid.conf /etc/squid/squid.conf.orig
RUN echo http_access allow all > /etc/squid/squid.conf
RUN cat /etc/squid/squid.conf.orig >> /etc/squid/squid.conf
RUN touch /var/log/squid/access.log /var/log/squid/store.log /var/log/squid/cache.log

EXPOSE 3128

COPY docker-entrypoint.sh /squid-entrypoint.sh
ENTRYPOINT ["/squid-entrypoint.sh"]
CMD ["squid", "-N", "-d", "1"]
