#!/bin/bash -ex

# Cleanup logs and packer instance config
find /var/log -type f -delete
rm -f  ~ubuntu/.ssh/authorized_keys
rm -f  /etc/ssh/*key*
rm -f  /usr/sbin/policy-rc.d
rm -fr /var/lib/cloud/*
rm -f  /etc/docker/*key*
rm -f  /opt/sumocollector/logs/*

# Cleanup Build Tools & Dependencies

# Cleanup python build dependencies
pip uninstall -y \
  ansible \
  docker-py \
  credstash

# Cleanup apt build dependencies
export DEBIAN_FRONTEND=noninteractive
apt-get remove -y --purge \
  python-dev \
  python-setuptools \
  libffi-dev \
  libncurses5-dev \
  libreadline-dev \
  libssl-dev \
  libxml2-dev \
  libxslt1-dev \
  build-essential

# Final apt cleaning
apt-get clean -yqq
apt-get autoclean -y
apt-get autoremove -y
rm -rf /var/lib/apt/lists/*

# Enable starting services on installation (after bootstrap)
rm -f /usr/sbin/policy-rc.d
