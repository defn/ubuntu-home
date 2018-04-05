FROM imma/ubuntu:start

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get upgrade -y

RUN install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu/.ssh
RUN curl -s https://github.com/defn.keys > /home/ubuntu/.ssh/authorized_keys
RUN chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys
RUN chmod 0600 /home/ubuntu/.ssh/authorized_keys

RUN install -d -m 0700 -o ubuntu -g ubuntu /data

COPY bootstrap /bootstrap
COPY service /service
ENTRYPOINT ["/service"]
CMD []
