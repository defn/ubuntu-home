FROM imma/ubuntu:bionic

RUN set -x \
  && apt-get update \
  && apt-get install -y curl

RUN mkdir -p /usr/local/bin
RUN echo 2018.4.6
RUN curl -s https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.tgz | tar xzC /usr/local/bin
RUN chmod 755 /usr/local/bin/cloudflared

RUN rm -rf /var/lib/apt/lists/*

EXPOSE 5353

COPY docker-entrypoint.sh /cloudflared-entrypoint.sh
ENTRYPOINT ["/cloudflared-entrypoint.sh"]
CMD ["cloudflared", "proxy-dns", "--port", "5353", "--address", "0.0.0.0"]
