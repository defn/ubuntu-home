FROM imma/ubuntu:shell

USER root
WORKDIR /
COPY bootstrap /bootstrap
COPY service /service

USER ubuntu
WORKDIR /home/ubuntu
COPY --chown=ubuntu:ubuntu data /data
RUN env SERVICE_DONE=/tmp/.done-base /service
RUN exec/home block base block stale
RUN sudo rm -rf /data || true
