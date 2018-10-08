#!/bin/bash -ex
# Installs the latest ansible release on debian style systems

export DEBIAN_FRONTEND=noninteractive

# Upgrade system and install ansible prereq packages
apt-get update
apt-get upgrade -y
apt-get install -y --fix-missing --no-install-recommends \
  aptitude \
  apt-transport-https \
  ca-certificates \
  ntp \
  ntpdate \
  python \
  python-dev \
  python-setuptools \
  ssh \
  vim \
  vim-tiny \
  libffi-dev \
  libncurses5-dev \
  libreadline-dev \
  libssl-dev \
  libxml2-dev \
  libxslt1-dev \
  build-essential

# Install prerequisite python packages for ansible
easy_install pip

# upgrade pip
pip install -U pip

# install pip modules
pip install --quiet --upgrade \
  pyopenssl \
  ndg-httpsclient \
  pyasn1 \
  ansible \
  awscli \
  docker-py \
  credstash

# Set up SSH config for GitHub
mkdir -p /root/.ssh/
printf "IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config
printf "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

# Synchronize the system date
# ntpdate -s

# Disable starting services on installation (during bootstrap)
cat <<HEREDOC > /usr/sbin/policy-rc.d
#!/bin/sh
exit 101
HEREDOC

chmod +x /usr/sbin/policy-rc.d

exit 0
