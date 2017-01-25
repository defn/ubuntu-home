#      _            _             
#   __| | ___   ___| | _____ _ __ 
#  / _` |/ _ \ / __| |/ / _ \ '__|
# | (_| | (_) | (__|   <  __/ |   
#  \__,_|\___/ \___|_|\_\___|_|   
                                
FROM cache.nih/block:ubuntu-home

ARG SERIAL
ARG CACHE

USER root

RUN echo ${CACHE} cache.nih >> /etc/hosts
RUN aptitude update && aptitude upgrade -y && echo ${SERIAL}

USER ubuntu

SHELL [ "/bin/bash", "-c" ]

WORKDIR /home/ubuntu

RUN source .bashrc && block compile service && ln -nfs ../sv/sshd ../sv/consul-agent service/
RUN rm -f service/ubuntu-home .ssh/authorized_keys
RUN touch .ssh/authorized_keys

ENTRYPOINT exec script/server
