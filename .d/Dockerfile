FROM docker.nih/block:ubuntu

ARG SERIAL
ARG CACHE

USER root

ADD etc/rc.local /etc/rc.local

USER ubuntu

SHELL [ "/bin/bash", "-c" ]

WORKDIR /home/ubuntu

RUN rm -f service/ubuntu

ENTRYPOINT [ "/home/ubuntu/script/server" ]
CMD [ "docker" ]
