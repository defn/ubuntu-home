FROM imma/ubuntu:shell

COPY --chown=ubuntu:ubuntu .ssh/authorized_keys /home/ubuntu/.ssh/authorized_keys
RUN chmod 0600 /home/ubuntu/.ssh/authorized_keys
