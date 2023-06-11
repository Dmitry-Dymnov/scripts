#!/bin/bash
mkdir /etc/docker /var/lib/docker
echo -e '{
 "default-address-pools": [{"base":"10.10.0.0/16","size":24}],
 "log-driver": "json-file",
 "log-opts": {"max-size": "100m","max-file": "10"}
}' > /etc/docker/daemon.json
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io docker-compose
systemctl enable docker.service
systemctl start docker.service