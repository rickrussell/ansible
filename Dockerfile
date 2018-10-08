# Ansible Environment Image
#
# NAME rickrussell/ansible
# VERSION 1.6.2

FROM ubuntu:trusty

MAINTAINER Rick Russell <sysadmin.rick@gmail.com>

# Install dependencies
RUN buildDeps=' \
      build-essential \
      libffi-dev \
      libssl-dev \
      python-dev \
      python-setuptools \
    ' \
    && set -x \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends --fix-missing -y \
      $buildDeps \
      ca-certificates \
      openssl \
      curl \
      git \
      python
RUN easy_install pip
RUN pip install pyOpenSSL ndg-httpsclient pyasn1 ansible boto boto3 cryptography
RUN pip install python-dateutil --upgrade
RUN pip install pytz --upgrade
RUN apt-get purge -y --auto-remove \
      -o APT::AutoRemove::RecommendsImportant=false \
      -o APT::AutoRemove::SuggestsImportant=false \
      $buildDeps
RUN rm -rf $HOME/.cache
RUN rm -rf /var/lib/apt/lists/*

COPY . /etc/ansible
WORKDIR /etc/ansible
RUN ansible-playbook -i tests/inventory tests/test.yml --connection=local

# Define default command.
#CMD ["/bin/bash"]
