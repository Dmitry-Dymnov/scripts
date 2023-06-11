#!/bin/bash
mkdir -p /var/lib/docker/vault/{data,ssl,config}
echo -e '{
 "default-address-pools": [{"base":"10.10.0.0/16","size":24}],
 "log-driver": "json-file",
 "log-opts": {"max-size": "100m","max-file": "10"}
}' > /etc/docker/daemon.json
dnf install -y dnf-utils zip unzip
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf remove -y runc
dnf install -y docker-ce --nobest
systemctl enable docker.service
systemctl start docker.service