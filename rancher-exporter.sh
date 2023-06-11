#!/bin/bash
token="YOUR RANCHER TOKEN"
rancher_api_url='YOUR RANCHER API URL'
download_cluster_id_array=$(curl -k -s -u "$token" -X GET "$rancher_api_url/clusters" --output /tmp/clusters.tmp)
cluster_id_array=$(cat /tmp/clusters.tmp | jq .data[].id | sed 's/\"//g')
for cluster_id in $cluster_id_array
do
if [ "$cluster_id" != "local" ]; then
download_cluster_id=$(curl -k -s -u "$token" -X GET "$rancher_api_url/clusters/$cluster_id" --output /tmp/$cluster_id.tmp)
cluster_name=$(cat /tmp/$cluster_id.tmp | jq .appliedSpec.displayName | sed 's/\"//g' &) 
cluster_allocatable_cpu=$(cat /tmp/$cluster_id.tmp | jq .allocatable.cpu | sed 's/\"//g' &) \
&& echo "cluster_allocatable_cpu{cluster="'"'$cluster_name'"'"} $cluster_allocatable_cpu" &
cluster_allocatable_memory=$(cat /tmp/$cluster_id.tmp | jq .allocatable.memory | sed 's/\"//g' | awk '{if ($1~"Ki") print $1/1024/1024; else if ($1~"Mi") print $1/1024; else if ($1~"Gi") print $1; else if ($1~"m") print $1/1024/1024/1024/1024; else print $1/1024/1024/1024}' &) \
&& echo "cluster_allocatable_memory{cluster="'"'$cluster_name'"'"} $cluster_allocatable_memory" &
cluster_allocatable_pods=$(cat /tmp/$cluster_id.tmp | jq .allocatable.pods | sed 's/\"//g' &) \
&& echo "cluster_allocatable_pods{cluster="'"'$cluster_name'"'"} $cluster_allocatable_pods" &
cluster_requested_cpu=$(cat /tmp/$cluster_id.tmp | jq .requested.cpu | sed 's/\"//g' | awk '{print $1/1000}' &) \
&& echo "cluster_requested_cpu{cluster="'"'$cluster_name'"'"} $cluster_requested_cpu" &
cluster_requested_memory=$(cat /tmp/$cluster_id.tmp | jq .requested.memory | sed 's/\"//g' | awk '{if ($1~"Ki") print $1/1024/1024; else if ($1~"Mi") print $1/1024; else if ($1~"Gi") print $1; else if ($1~"m") print $1/1024/1024/1024/1024; else print $1/1024/1024/1024}' &) \
&& echo "cluster_requested_memory{cluster="'"'$cluster_name'"'"} $cluster_requested_memory" &
cluster_requested_pods=$(cat /tmp/$cluster_id.tmp | jq .requested.pods | sed 's/\"//g' &) \
&& echo "cluster_requested_pods{cluster="'"'$cluster_name'"'"} $cluster_requested_pods" &
cluster_limits_cpu=$(cat /tmp/$cluster_id.tmp | jq .limits.cpu | sed 's/\"//g' | awk '{print $1/1000}' &) \
&& echo "cluster_limits_cpu{cluster="'"'$cluster_name'"'"} $cluster_limits_cpu" &
cluster_limits_memory=$(cat /tmp/$cluster_id.tmp | jq .limits.memory | sed 's/\"//g' | awk '{if ($1~"Ki") print $1/1024/1024; else if ($1~"Mi") print $1/1024; else if ($1~"Gi") print $1; else if ($1~"m") print $1/1024/1024/1024/1024; else print $1/1024/1024/1024}' &) \
&& echo "cluster_limits_memory{cluster="'"'$cluster_name'"'"} $cluster_limits_memory" &
cluster_agent_features=$(cat /tmp/$cluster_id.tmp | jq .agentFeatures | jq 'keys[]' | sed 's/\"//g' &)
for cluster_agent_feature in $cluster_agent_features
do
cluster_agent_features_status=$(cat /tmp/$cluster_id.tmp | jq '.agentFeatures."'$cluster_agent_feature'"' | sed 's/\"//g' | awk '{if ($1~"true") print 1; else if ($1~"false") print 0; else print $1}' &) \
&& echo "cluster_agent_features{cluster="'"'$cluster_name'"'",cluster_agent_feature="'"'$cluster_agent_feature'"'"} $cluster_agent_features_status" &
done
cluster_conditions=$(cat /tmp/$cluster_id.tmp | jq .conditions[].type | sed 's/\"//g' &)
for cluster_condition in $cluster_conditions
do
cluster_condition_status=$(cat /tmp/$cluster_id.tmp | jq .conditions[] | jq 'select(.type == "'$cluster_condition'")' | jq .status | sed 's/\"//g' | awk '{if ($1~"True") print 1; else if ($1~"False") print 0; else print $1}' &) \
&& echo "cluster_condition{cluster="'"'$cluster_name'"'",cluster_condition="'"'$cluster_condition'"'"} $cluster_condition_status" &
done
node_name_array=$(cat /tmp/$cluster_id.tmp | jq .appliedSpec.rancherKubernetesEngineConfig.nodes[].hostnameOverride | sed 's/\"//g' &)
download_cluster_nodes=$(curl -k -s -u "$token" -X GET "$rancher_api_url/nodes" --output /tmp/k8s-nodes.tmp &)
for node_name in $node_name_array
do
NODE=`cat /tmp/k8s-nodes.tmp | jq .data[] | jq 'select(.hostname == "'$node_name'")'`
node_allocatable_cpu=$(echo $NODE | jq .allocatable.cpu | sed 's/\"//g' &) \
&& echo "node_allocatable_cpu{cluster="'"'$cluster_name'"'",node_name="'"'$node_name'"'"} $node_allocatable_cpu" &
node_allocatable_memory=$(echo $NODE | jq .allocatable.memory | sed 's/\"//g' | awk '{if ($1~"Ki") print $1/1024/1024; else if ($1~"Mi") print $1/1024; else if ($1~"Gi") print $1; else if ($1~"m") print $1/1024/1024/1024/1024; else print $1/1024/1024/1024}' &) \
&& echo "node_allocatable_memory{cluster="'"'$cluster_name'"'",node_name="'"'$node_name'"'"} $node_allocatable_memory" &
node_allocatable_pods=$(echo $NODE | jq .allocatable.pods | sed 's/\"//g' &) \
&& echo "node_allocatable_pods{cluster="'"'$cluster_name'"'",node_name="'"'$node_name'"'"} $node_allocatable_pods" &
node_requested_cpu=$(echo $NODE | jq .requested.cpu | sed 's/\"//g' | awk '{print $1/1000}' &) \
&& echo "node_requested_cpu{cluster="'"'$cluster_name'"'",node_name="'"'$node_name'"'"} $node_requested_cpu" &
node_requested_memory=$(echo $NODE | jq .requested.memory | sed 's/\"//g' | awk '{if ($1~"Ki") print $1/1024/1024; else if ($1~"Mi") print $1/1024; else if ($1~"Gi") print $1; else if ($1~"m") print $1/1024/1024/1024/1024; else print $1/1024/1024/1024}' &) \
&& echo "node_requested_memory{cluster="'"'$cluster_name'"'",node_name="'"'$node_name'"'"} $node_requested_memory" &
node_requested_pods=$(echo $NODE | jq .requested.pods | sed 's/\"//g' &) \
&& echo "node_requested_pods{cluster="'"'$cluster_name'"'",node_name="'"'$node_name'"'"} $node_requested_pods" &
node_components=$(echo $NODE | jq .conditions[].type | sed 's/\"//g' | uniq &)
for node_component in $node_components
do
node_component_status=$(echo $NODE | jq .conditions[] | jq 'select(.type == "'$node_component'")' | jq .status | head -1 | sed 's/\"//g' | awk '{if ($1~"True") print 1; else if ($1~"False") print 0; else print $1}' &)
echo "node_component_status{cluster="'"'$cluster_name'"'",node_name="'"'$node_name'"'", node_component="'"'$node_component'"'"} $node_component_status"
done
done
else
echo "#You do not need to monitor the local cluster"
fi
done
