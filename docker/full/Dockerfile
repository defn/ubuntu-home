FROM imma/ubuntu:base

USER root
COPY bootstrap /bootstrap
COPY service /service

USER ubuntu
COPY --chown=ubuntu:ubuntu data /data
RUN env SERVICE_DONE=/tmp/.done-full /service
RUN exec/home block stale
