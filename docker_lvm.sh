#!/bin/bash
mkdir /var/lib/docker
pvcreate /dev/sdb
vgcreate vgdocker /dev/sdb
lvcreate -n lvdocker -l+100%FREE vgdocker
mkfs.ext4 /dev/mapper/vgdocker-lvdocker
sleep 10
echo "/dev/mapper/vgdocker-lvdocker /var/lib/docker ext4 defaults 1 2" >> /etc/fstab
mount -a