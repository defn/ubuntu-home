FROM imma/ubuntu:shell

ARG ECHO

USER root
WORKDIR /
COPY bootstrap /bootstrap
COPY service /service

USER ubuntu
WORKDIR /home/ubuntu
RUN mkdir -p /data/cache/packages
COPY --chown=ubuntu:ubuntu data /data
RUN env SERVICE_DONE=/tmp/.done-base /service
RUN ${ECHO} rm -rf /data/*
