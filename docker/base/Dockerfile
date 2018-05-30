FROM imma/ubuntu:shell

USER root
COPY bootstrap /bootstrap
COPY service /service

USER ubuntu
RUN env SERVICE_DONE=/tmp/.done-base /service
