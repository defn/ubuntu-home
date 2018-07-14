FROM imma/ubuntu:shell

USER ROOT

USER root
WORKDIR /
RUN /service

USER ubuntu
WORKDIR /home/ubuntu
