FROM alpine:3.7

ENV container docker

RUN apk update && apk add openssh curl make sudo bash which git rsync findutils python perl build-base

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N ''

RUN addgroup -g 1000 ubuntu && adduser -u 1000 -s /bin/bash -h /home/ubuntu -D -G ubuntu ubuntu
RUN passwd ubuntu -d '*'

RUN echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "Defaults !requiretty" >> /etc/sudoers
RUN install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu/.ssh

COPY .ssh/authorized_keys /home/ubuntu/.ssh/authorized_keys
RUN chown ubuntu /home/ubuntu/.ssh/authorized_keys
RUN chmod 0600 /home/ubuntu/.ssh/authorized_keys
