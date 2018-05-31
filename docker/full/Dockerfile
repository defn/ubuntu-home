FROM imma/ubuntu:base

ARG ECHO

USER root
COPY bootstrap /bootstrap
COPY service /service

USER ubuntu
RUN mkdir -p /data/cache/packages
COPY --chown=ubuntu:ubuntu data /data
RUN env SERVICE_DONE=/tmp/.done-full /service
RUN ${ECHO} rm -rf /data/*
