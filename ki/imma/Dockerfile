FROM imma:ubuntu

ENV container docker

ENV DEBIAN_FRONTEND noninteractive
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

COPY .kitchen/docker_id_rsa.pub /home/ubuntu/.ssh/authorized_keys
COPY .kitchen/docker_id_rsa /home/ubuntu/.ssh/id_rsa
COPY .kitchen/docker_id_rsa /root/.ssh/id_rsa

RUN chown -R ubuntu /home/ubuntu/.ssh
RUN chmod 0600 /home/ubuntu/.ssh/authorized_keys
RUN chmod 0600 /home/ubuntu/.ssh/id_rsa

RUN chown -R root:root /root/.ssh
RUN chmod 0600 /root/.ssh/id_rsa
