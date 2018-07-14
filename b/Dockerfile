FROM imma/ubuntu:shell

USER root
WORKDIR /
RUN /service

USER ubuntu
WORKDIR /home/ubuntu
COPY --chown=ubuntu:ubuntu .ssh/authorized_keys /home/ubuntu/.ssh/authorized_keys
RUN chmod 0600 /home/ubuntu/.ssh/authorized_keys
