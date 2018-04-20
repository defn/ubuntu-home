FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

RUN apt-get update && apt-get install -y openssh-server curl lsb-release sudo make locales python build-essential aptitude rsync jq netcat software-properties-common net-tools dnsmasq unzip perl ruby language-pack-en vim man screen runit nfs-common portmap gettext-base libffi-dev libssl-dev libreadline-dev zlib1g-dev libxml2-dev libxslt1-dev autoconf automake libtool
RUN add-apt-repository -y ppa:git-core/ppa && apt-get update && apt-get install -y git
RUN apt-get update && apt-get upgrade -y

RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure --frontend=noninteractive locales
RUN update-locale LANG=en_US.UTF-8

RUN groupadd -g 497 docker
RUN groupadd -g 1000 ubuntu
RUN useradd -u 1000 -g ubuntu -d /home/ubuntu -m -s /bin/bash -p '*' ubuntu
RUN usermod -G docker ubuntu

RUN echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "Defaults !requiretty" >> /etc/sudoers

RUN install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu/.ssh
RUN curl -s https://github.com/defn.keys > /home/ubuntu/.ssh/authorized_keys
RUN chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys
RUN chmod 0600 /home/ubuntu/.ssh/authorized_keys

RUN install -d -m 0700 -o ubuntu -g ubuntu /data

RUN ln -nfs /usr/include/locale.h /usr/include/xlocale.h

COPY bootstrap /bootstrap
COPY service /service
ENTRYPOINT ["/service"]
CMD []
