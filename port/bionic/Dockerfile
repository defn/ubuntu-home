FROM ubuntu:bionic

RUN set -x \
  && groupadd -r ubuntu --gid=1000 \
  && useradd -r -g ubuntu --uid=1000 ubuntu

RUN set -x \
	&& apt-get update \
	&& apt-get install -y locales wget curl ca-certificates \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8
RUN apt-get upgrade -y

ENV GOSU_VERSION 1.10
RUN set -x \
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true

COPY docker-entrypoint.sh /uname-entrypoint.sh
ENTRYPOINT ["/uname-entrypoint.sh"]
CMD ["uname", "-a"]
