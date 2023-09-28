

#!/bin/bash



# Set the namespace and deployment name

NAMESPACE=${NAMESPACE}

DEPLOYMENT=${DEPLOYMENT_NAME}



# Get the current number of replicas

REPLICAS=$(kubectl get deployment $DEPLOYMENT -n $NAMESPACE -o jsonpath='{.spec.replicas}')



# Check if the current number of replicas is less than the desired number

if [ $REPLICAS -lt ${DESIRED_REPLICAS} ]; then

  # Scale up the deployment to the desired number of replicas

  kubectl scale deployment $DEPLOYMENT --replicas=${DESIRED_REPLICAS} -n $NAMESPACE

  echo "Scaled up $DEPLOYMENT deployment to ${DESIRED_REPLICAS} replicas."

else

  echo "$DEPLOYMENT deployment already has ${DESIRED_REPLICAS} replicas."

fi