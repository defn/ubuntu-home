FROM imma/ubuntu:shell

USER ubuntu
WORKDIR /home/ubuntu
COPY update /update
RUN /update
RUN cp .gitconfig.template .gitconfig
