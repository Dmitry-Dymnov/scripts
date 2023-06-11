#!/bin/bash
lun=$1
volume_group=$2
logical_volume=$3
mp=$4
echo -e "\n\n Partition creation is begin"
pvcreate $lun
echo -e "\nPhysical Volume $lun Created"
vgextend $volume_group $lun
echo -e "\n Volume Group $volume_group Created"
lvextend -l +100%FREE /dev/$volume_group/$logical_volume 
echo -e "\n Logical Volume $logical_volume Extended"
resize2fs /dev/$volume_group/$logical_volume 
echo -e "\n Filesystem resized"
mount -a
s=$(df -h | grep $mp | awk '{print $1}')
echo -e "\nExtendeded LUN $mp = $s "
echo -e "Partition successfully extended"