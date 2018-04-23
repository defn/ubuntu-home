FROM imma/ubuntu:bionic

RUN curl -Ss https://my-netdata.io/kickstart-static64.sh | bash -s -- --dont-wait --dont-start-it

EXPOSE 19999

COPY docker-entrypoint.sh /netdata-entrypoint.sh
ENTRYPOINT ["/netdata-entrypoint.sh"]
CMD []
