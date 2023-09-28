bash

#!/bin/bash



# Set the namespace and deployment names for Prometheus

NAMESPACE=${NAMESPACE}

DEPLOYMENT=${DEPLOYMENT_NAME}



# Get the current CPU and memory usage for the Prometheus pod

CPU_USAGE=$(kubectl top pods -n $NAMESPACE | grep $DEPLOYMENT | awk '{print $2}')

MEMORY_USAGE=$(kubectl top pods -n $NAMESPACE | grep $DEPLOYMENT | awk '{print $3}')



# Check if the CPU or memory usage is above a certain threshold

if (( $(echo "$CPU_USAGE > 80" | bc -l) )) || (( $(echo "$MEMORY_USAGE > 80" | bc -l) )); then

  echo "The server hosting the Prometheus exporter may be overloaded with traffic."

  echo "CPU usage: $CPU_USAGE"

  echo "Memory usage: $MEMORY_USAGE"

else

  echo "No issues found with Prometheus pod."

fi