
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Overheating reported by Prometheus exporter at {{ $labels.instance }} for Cassandra service.
---

This incident type refers to the report of overheating by Prometheus exporter at a specific instance for the Cassandra service. It could be caused by a high volume of traffic or some issues with the server, and it requires immediate attention to avoid any potential downtime or data loss. The incident is assigned to an engineer who will investigate and resolve the issue as quickly as possible.

### Parameters
```shell
export PROMETHEUS_EXPORTER_POD_NAME="PLACEHOLDER"

export PROMETHEUS_NODE_EXPORTER_POD_NAME="PLACEHOLDER"

export NAMESPACE="PLACEHOLDER"

export DEPLOYMENT_NAME="PLACEHOLDER"

export DESIRED_REPLICAS="PLACEHOLDER"
```

## Debug

### Check the status of the Cassandra pods
```shell
kubectl get pods -l app=cassandra
```

### Check the CPU and memory usage of the Cassandra pods
```shell
kubectl top pods -l app=cassandra
```

### Check the CPU and memory usage of the Prometheus exporter pod
```shell
kubectl top pods -l app=prometheus-exporter
```

### View the logs of the Prometheus exporter pod
```shell
kubectl logs ${PROMETHEUS_EXPORTER_POD_NAME}
```

### Check the status of the Prometheus service
```shell
kubectl get svc prometheus
```

### Check the status of the Prometheus Node Exporter pods
```shell
kubectl get pods -l app=prometheus-node-exporter
```

### View the logs of the Prometheus Node Exporter pod
```shell
kubectl logs ${PROMETHEUS_NODE_EXPORTER_POD_NAME}
```

### The server hosting the Prometheus exporter may be overloaded with traffic, causing it to overheat and trigger the incident.
```shell
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


```

## Repair

### If the overheating is caused by high traffic, consider scaling up the server or optimizing the Cassandra service to handle the load.
```shell


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


```