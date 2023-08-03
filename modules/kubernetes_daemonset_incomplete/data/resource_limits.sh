#!/bin/bash

# Set the namespace and daemonset name

NAMESPACE=${NAMESPACE}
DAEMONSET=${DAEMONSET_NAME}
CONTAINER_NAME="PLACEHOLDER"

# Check the current resource limits

kubectl describe daemonset $DAEMONSET -n $NAMESPACE | grep -A 3 Resources
 
# Set the desired CPU and memory limits
cpu_limit="PLACEHOLDER"
memory_limit="PLACEHOLDER"

# Adjust the resource limits
kubectl patch deployments/$deployment_name -p \
  '{"spec":{"template":{"spec":{"containers":[{"name":"'$CONTAINER_NAME'","resources":{"limits":{"cpu":"'$cpu_limit'","memory":"'$memory_limit'"}}}]}}}}'


# Check the new resource limits

kubectl describe daemonset $DAEMONSET -n $NAMESPACE | grep -A 3 Resources