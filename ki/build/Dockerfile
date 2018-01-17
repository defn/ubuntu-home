FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

RUN apt-get update && apt-get upgrade -y && apt-get install -y openssh-server curl lsb-release sudo make locales python build-essential aptitude git rsync jq
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure --frontend=noninteractive locales
RUN update-locale LANG=en_US.UTF-8

RUN groupadd -g 1000 ubuntu
RUN useradd -u 1000 -g ubuntu -d /home/ubuntu -m -s /bin/bash -p '*' ubuntu

RUN echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "Defaults !requiretty" >> /etc/sudoers

ENTRYPOINT ["/data/script/service"]
CMD ["/usr/sbin/sshd", "-D", "-o", "UseDNS=no", "-o", "UsePAM=no", "-o", "PasswordAuthentication=yes", "-o", "UsePrivilegeSeparation=no", "-o", "PidFile=/tmp/sshd.pid"]

COPY . /tmp/cache

RUN install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu/.ssh
COPY .ssh/authorized_keys /home/ubuntu/.ssh/authorized_keys
RUN chmod 0600 /home/ubuntu/.ssh/authorized_keys
RUN chown -R ubuntu:ubuntu /home/ubuntu
