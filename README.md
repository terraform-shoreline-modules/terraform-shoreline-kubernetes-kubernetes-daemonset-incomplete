
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kubernetes Daemonset Incomplete
---

This incident type occurs when a Kubernetes DaemonSet fails to run the same pod across all nodes due to reasons such as missing images, initialization failures, or a lack of resources in the cluster. The incident is triggered when the desired number of pods - the running pods is greater than zero. This incident can impact the availability of the services running on Kubernetes and requires immediate attention.

### Parameters
```shell
# Environment Variables

export NAMESPACE="PLACEHOLDER"

export DAEMONSET_NAME="PLACEHOLDER"

export APP_NAME="PLACEHOLDER"

export POD_NAME="PLACEHOLDER"

```

## Debug

### Get the list of DaemonSets in the cluster
```shell
kubectl get daemonsets --all-namespaces
```

### Describe a specific DaemonSet to check its status
```shell
kubectl describe daemonset ${DAEMONSET_NAME} --namespace ${NAMESPACE}
```

### Check the status of the pods created by the DaemonSet
```shell
kubectl get pods --selector=app=${APP_NAME} --namespace ${NAMESPACE}
```

### Check the logs of a specific pod to see if there are any errors
```shell
kubectl logs ${POD_NAME} --namespace ${NAMESPACE}
```

### Check the events related to the DaemonSet to see if there were any issues during the creation of the pods
```shell
kubectl get events --field-selector involvedObject.kind=DaemonSet --namespace ${NAMESPACE}
```

### Check the status of the nodes in the cluster to see if there are any issues
```shell
kubectl get nodes
```

### Check the resource usage of the nodes to see if there are any resource constraints
```shell
kubectl top nodes
```


### The pod spec in the DaemonSet configuration could be incorrect or incomplete.
```shell

#!/bin/bash
# Specify the DaemonSet name and namespace

DAEMONSET_NAME=${DAEMONSET_NAME}

NAMESPACE=${NAMESPACE}

# Get the pod template from the DaemonSet's YAML file

POD_TEMPLATE=$(kubectl get daemonset/${DAEMONSET_NAME} -n ${NAMESPACE} -o jsonpath='{.spec.template}')

# Check if the pod template is empty or incomplete

if [[ -z ${POD_TEMPLATE} ]]; then

    echo "ERROR: The pod template in the DaemonSet ${DAEMONSET_NAME} is empty."

    exit 1

fi

# Check if any required fields are missing from the pod template

if [[ -z $(echo ${POD_TEMPLATE} | jq '.spec.containers[].image') ]]; then

    echo "ERROR: The image field is missing from the pod template in the DaemonSet ${DAEMONSET_NAME}."

    exit 1

fi

# Check if any optional fields are missing from the pod template

if [[ -z $(echo ${POD_TEMPLATE} | jq '.spec.containers[].resources') ]]; then

    echo "WARNING: The resources field is missing from the pod template in the DaemonSet ${DAEMONSET_NAME}."

fi

echo "SUCCESS: The pod template in the DaemonSet ${DAEMONSET_NAME} is correct."

exit 0

```
## Repair
### Review the Kubernetes resource limits for the daemonset and adjust as necessary.
```shell
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


```