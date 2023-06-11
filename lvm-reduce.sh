#!/bin/bash
lun=$1
volume_group=$2
logical_volume=$3
mp=$4
logical_volume_size=$5
umount $mp
echo -e "\n Logical Volume reduce to $logical_volume_size $logical_volume"
lvreduce -r -L $logical_volume_size /dev/$volume_group/$logical_volume
echo -e "\n Physical volume move from $logical_volume_size $logical_volume"
pvmove $lun
echo -e "\n Reduce $logical_volume_size from $volume_group"
vgreduce $volume_group $lun
echo -e "\n Physical volume remove $lun"
pvremove $lun
lvextend -l +100%FREE /dev/$volume_group/$logical_volume 
echo -e "\n Logical Volume $logical_volume Extended"
resize2fs -p /dev/$volume_group/$logical_volume 
echo -e "\n Filesystem resized"
mount -a
s=` df -h | grep $mp | awk '{print $1}'`
echo -e "\nExtendeded LUN $mp = $s "
echo -e "Partition successfully extended, $lun was deleted"