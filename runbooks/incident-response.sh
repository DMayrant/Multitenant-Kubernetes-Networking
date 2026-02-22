#!/bin/bash
set -e 

# The highest priority is containing the blast radius and ensuring other workloads in the namespace are not compromised 
#Step 1. Check logs 🔍

kubectl get pods -n <ns> 

kubectl describe pod <pod-name> -n <ns>

kubectl logs deploy/<deployment-name> -n <ns>

kubectl logs -f <pod> -n <ns>

# If YAML ❗️ access isn't readily available 
kubectl get pod -n <namespace> -o yaml

# Step 2. Minimize downtime and Containment ☣️
kubectl scale deploy <deployment> -n <ns> --replicas=2

kubectl rollout undo deploy <deployment> -n <ns>

# Double check logs and deployment status
kubectl rollout history deploy <deployment> -n <ns> 

kubectl logs deploy/<deployment> -n <ns>

# Step 3. Record change cause (Operational traceability)📚 
# Annotate 📝 if any changes are made
kubectl annotate deploy <deployment> -n <ns> kubernetes.io/change-cause="<change-description>"

# Overwrite 🖋️ an existing change-cause annotation 

kubectl annotate deploy <deployment> -n <ns> kubernetes.io/change-cause="<overwrite-message>" --overwrite

# Step 4. Health checks ✅

kubectl get deploy <deployment> -n <ns> -o wide

kubectl get pod <pod-name> -n <ns> -o wide

# Step 5. Capturing error logs from failed pods or deployments (CrashloopBackOff)
kubectl logs deploy/<deployment> -n <ns> --previous > /tmp/failed-logs.log
