FROM zerotier/zerotier-containerized

RUN set -x \
  && apk update && apk add bash

EXPOSE 9993

COPY docker-entrypoint.sh /zerotier-entrypoint.sh
ENTRYPOINT ["/zerotier-entrypoint.sh"]
CMD ["/zerotier-one", "-U"]
