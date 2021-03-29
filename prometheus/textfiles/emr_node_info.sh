#!/bin/bash
#
## Description: get EMR instance role
#
ROLE=$(cat /var/aws/emr/userData.json | jq -r '.isMaster')
CLUSTER_ID=$(cat /var/aws/emr/userData.json | jq -r '.clusterId')
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

echo '# HELP emr_node_info EMR cluster info'
echo '# TYPE emr_node_info gauge'
if [ ${ROLE} == 'true' ]
then
    echo "emr_node_info{isMaster=\"true\",isSlave=\"false\",cluster_id=\"${CLUSTER_ID}\",instance_id=\"${INSTANCE_ID}\"} 1"
else
    echo "emr_node_info{isMaster=\"false\",isSlave=\"true\",cluster_id=\"${CLUSTER_ID}\",instance_id=\"${INSTANCE_ID}\"} 1"
fi