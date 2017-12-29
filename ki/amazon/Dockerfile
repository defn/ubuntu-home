FROM amazonlinux:2017.12

ENV container docker

RUN yum update -y && yum install -y sudo openssh-server openssh-clients which curl make

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N ''

RUN groupadd -g 1000 ubuntu
RUN useradd -u 1000 -g ubuntu -d /home/ubuntu -m -s /bin/bash -p '*' ubuntu

RUN echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "Defaults !requiretty" >> /etc/sudoers
RUN install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu/.ssh

COPY .ssh/authorized_keys /home/ubuntu/.ssh/authorized_keys
RUN chown ubuntu /home/ubuntu/.ssh/authorized_keys
RUN chmod 0600 /home/ubuntu/.ssh/authorized_keys
