#      _            _             
#   __| | ___   ___| | _____ _ __ 
#  / _` |/ _ \ / __| |/ / _ \ '__|
# | (_| | (_) | (__|   <  __/ |   
#  \__,_|\___/ \___|_|\_\___|_|   
                                
FROM 172.28.128.1/block:ubuntu-home

USER root

ARG SERIAL

RUN aptitude update && aptitude upgrade -y && echo ${SERIAL}

USER ubuntu

SHELL [ "/bin/bash", "-c" ]

WORKDIR /home/ubuntu

RUN source .bashrc && block compile service && ln -nfs ../sv/sshd ../sv/consul-agent service/
RUN rm -f service/ubuntu-home

ENTRYPOINT exec script/server
