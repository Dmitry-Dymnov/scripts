#!/bin/bash
echo -e " \nScan and Detect newly connected SCSI LUN"
host=$(ls -l /sys/class/scsi_host/ | grep -v total | awk '{print $9}' | awk -F "host" '{print $2}')
for i in $host
do
echo "Rescaning scsi host /sys/class/scsi_host/host$i"
echo "- - -" > /sys/class/scsi_host/host$i/scan
done
echo -e "\n All the SCSI LUN scanned Sucessfully..."
lun=$1
volume_group=$2
logical_volume=$3
mp=$4
mkdir -p $mp
echo -e "\n\n Partition creation is begin"
#partx -av $lun
pvcreate $lun
echo -e "\n Physical Volume $lun created"
vgcreate $volume_group $lun
echo -e "\n Volume Group $volume_group created"
lvcreate -l 100%FREE -n $logical_volume $volume_group
echo -e "\n Logical Volume $logical_volume created"
mkfs.ext4 /dev/$volume_group/$logical_volume
echo "/dev/$volume_group/$logical_volume $mp ext4 defaults 1 2 " | cat >> /etc/fstab
mount -a
s=` df -h | grep $mp | awk '{print $1}'`
echo -e "\n Newly created LUN $mp = $s "
echo -e "Partition successfully created"