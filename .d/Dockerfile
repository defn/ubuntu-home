FROM docker.nih/block:ubuntu-home

ARG SERIAL
ARG CACHE

USER root

RUN aptitude update && aptitude upgrade -y

ADD etc/rc.local /etc/rc.local

USER ubuntu

SHELL [ "/bin/bash", "-c" ]

WORKDIR /home/ubuntu

RUN source .bashrc && block compile service && ln -nfs ../sv/sshd service/
RUN rm -f service/ubuntu-home .ssh/authorized_keys
RUN touch .ssh/authorized_keys

CMD script/server
