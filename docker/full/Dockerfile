FROM imma/ubuntu:base

USER root
COPY bootstrap /bootstrap
COPY service /service

USER ubuntu
RUN mkdir -p /data/cache/packages
COPY --chown=ubuntu:ubuntu Ubuntu_4_home_ubuntu_pkgsrc-2018Q1 /data/cache/packages/Ubuntu_4_home_ubuntu_pkgsrc-2018Q1
RUN env SERVICE_DONE=/tmp/.done-full /service
RUN rm -rf /data/*
