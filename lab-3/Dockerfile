FROM ubuntu:20.04

RUN apt-get update
RUN apt-get -y install wget gpg gnupg2 lsb-release

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install postgresql-14

RUN apt-get -y install locales locales-all

RUN apt-get -y install vim rsync

RUN apt-get -y install openssh-client openssh-server
RUN mkdir -p /run/sshd && chmod 755 /run/sshd
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin no" >> /etc/ssh/sshd_config

RUN useradd -ms /bin/bash postgres0
RUN echo "postgres0:changeme" | chpasswd
USER postgres0
WORKDIR /home/postgres0
RUN mkdir ~/.ssh
RUN touch ~/.ssh/authorized_keys

USER root
RUN cd /etc/ssh && ssh-keygen -A

CMD service ssh start && bash
EXPOSE 22
