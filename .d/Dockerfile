FROM docker.nih/block:ubuntu

ARG CACHE

USER root

ADD etc/rc.local /etc/rc.local

USER ubuntu

SHELL [ "/bin/bash", "-c" ]

WORKDIR /home/ubuntu

RUN rm -rf service sv
RUN git checkout service sv
RUN source .bashrc && block compile service sshd
RUN ln -nfs ../sv/sshd service/

ENTRYPOINT [ "/home/ubuntu/script/server" ]
