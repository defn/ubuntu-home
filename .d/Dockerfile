FROM docker.nih/block:ubuntu

ARG CACHE

USER root

ADD etc/rc.local /etc/rc.local

USER ubuntu

SHELL [ "/bin/bash", "-c" ]

WORKDIR /home/ubuntu

RUN rm -rf service sv
RUN git checkout service sv

ENTRYPOINT [ "/home/ubuntu/script/server" ]

COMMAND [ "sshd", "default" ]
