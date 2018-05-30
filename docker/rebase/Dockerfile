FROM imma/ubuntu:full

USER root
COPY bootstrap /bootstrap
COPY service /service

USER ubuntu
RUN env SERVICE_DONE=/tmp/.done-rebase /service
