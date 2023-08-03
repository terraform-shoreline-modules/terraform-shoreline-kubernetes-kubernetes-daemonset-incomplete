
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