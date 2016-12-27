#      _            _             
#   __| | ___   ___| | _____ _ __ 
#  / _` |/ _ \ / __| |/ / _ \ '__|
# | (_| | (_) | (__|   <  __/ |   
#  \__,_|\___/ \___|_|\_\___|_|   
                                
FROM 172.28.128.1:5000/block:ubuntu-home

#RUN aptitude update

#RUN aptitude upgrade -y

USER ubuntu

SHELL [ "/bin/bash", "-c" ]

WORKDIR /home/ubuntu

RUN cd && source .bashrc && block compile service

RUN ln -nfs ../sv/sshd service/

ENTRYPOINT exec script/server
