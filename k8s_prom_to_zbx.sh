#!/bin/bash
if [ "$1" == "list_1" ]; then
autodiscovery=$(curl -s -G --data-urlencode 'query='$2'{'$3','$4'}' $5/api/v1/query | jq $6)
arr=($autodiscovery)
printf '{"data": ['
for host in "${arr[@]}"
do
if [ "$host" != "${arr[${#arr[@]}-1]}" ]; then
printf '{"{#VHOSTNAME}": '$host"}, "
else
printf '{"{#VHOSTNAME}": '$host"}]}"
fi
done
elif [ "$1" == "list_2" ]; then
autodiscovery=$(curl -s -G --data-urlencode 'query='$2'{'$3','$4','$5'}' $6/api/v1/query | jq $7)
arr=($autodiscovery)
printf '{"data": ['
for host in "${arr[@]}"
do
if [ "$host" != "${arr[${#arr[@]}-1]}" ]; then
printf '{"{#VHOSTNAME}": '$host"}, "
else
printf '{"{#VHOSTNAME}": '$host"}]}"
fi
done
elif [ "$1" == "watch_1" ]; then
curl -s -G --data-urlencode 'query='$2'{'$3','$4'}'$5'' $6/api/v1/query
elif [ "$1" == "watch_2" ]; then
curl -s -G --data-urlencode 'query='$2'{'$3','$4','$5'}'$6'' $7/api/v1/query
else
printf "ERROR"
fi