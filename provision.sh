#!/bin/bash
# provision.sh for Vagrant Bento Ubuntu 18.04

set -e -o pipefail -x

export DEBIAN_FRONTEND=noninteractive

apt-get clean
rm -rf /var/lib/apt/lists/*

#cat > /etc/apt/apt.conf.d/docker-ignore-secure.conf <<EOFILE
#Acquire::https::download.docker.com::Verify-Peer "false";
#Acquire::https::download.docker.com::Verify-Host "false";
#EOFILE

curl -k -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88

# --allow-unauthenticated 
apt-get update --fix-missing -y

# Upgrade all packages to the latest, and resolve dependencies
#apt-get --fix-missing -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

# Install a bunch of tools useful for a development environment
apt-get install --fix-missing -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    python3 \
    python3-pip \
    python3-wheel \
    python3-virtualenv \
    xauth \
    rxvt \
    x11-xserver-utils \
    bash-completion \
    ldap-utils \
    sendmail \
    bsd-mailx \
    jq \
    ntp \
    ntpdate

# If you need to modify your DNS servers, you may need the following configuration:
# 1. Create this file
#      # /etc/systemd/resolved.conf
#      [Resolve]
#      DNS=10.90.163.133 10.90.131.133 8.8.8.8 1.1.1.1
#
# 2. Copy /lib/systemd/system/docker.service to /etc/systemd/system/
# 3. Add '--dns <ip1> --dns <ip2> ...' to /etc/systemd/system/docker.service
# 4. Run 'systemctl daemon-reload ; systemctl restart docker ; systemctl enable docker
# 5. Enable tcp mode in docker daemon

# Set timezone to US/Eastern
sudo timedatectl set-timezone US/Eastern

# Install Docker
(
    # Don't fail for the docker install
    set +e
    curl -k -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    apt-key fingerprint 0EBFCD88
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update
    apt-get install -y "docker-ce"
    unset http_proxy https_proxy no_proxy
    docker info
    usermod -a -G docker vagrant
) || true

rm -f /etc/apt/apt.conf.d/docker-ignore-secure.conf
