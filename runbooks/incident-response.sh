#!/bin/bash
set -euo pipefail

NS="team-a"
DEPLOY="team-a-app"
POD="nginx"

# The highest priority is containing the blast radius and ensuring other workloads in the namespace are not compromised 
#Step 1. Check logs 🔍

kubectl get pods -n "$NS" 
kubectl describe pod "$POD" -n "$NS"
kubectl logs deploy/"$DEPLOY" -n "$NS"
kubectl logs -f "$POD" -n "$NS"
kubectl get events -n "$NS" --sort-by=.lastTimestamp | tail -n 30
kubectl top nodes 
kubectl top pods -n "$NS"

# If YAML ❗️ access isn't readily available 
kubectl get pod -n "$NS" -o yaml > /tmp/pod.yaml

# Step 2. Minimize downtime and Containment ☣️
kubectl scale deploy "$DEPLOY" -n "$NS" --replicas=2
kubectl rollout undo deploy "$DEPLOY" -n "$NS"

# Double check logs and deployment status
kubectl rollout history deploy "$DEPLOY" -n "$NS" 
kubectl logs deploy/"$DEPLOY" -n "$NS"

# Step 3. Record change cause (Operational traceability)📚 
# Annotate 📝 if any changes are made
kubectl annotate deploy "$DEPLOY" -n "$NS" kubernetes.io/change-cause="<change-description>"

# Overwrite 🖋️ an existing change-cause annotation 

kubectl annotate deploy "$DEPLOY" -n "$NS" kubernetes.io/change-cause="<overwrite-message>" --overwrite

# Step 4. Health checks ✅

kubectl get deploy "$DEPLOY" -n "$NS" -o wide
kubectl get pod "$POD" -n "$NS" -o wide

# Step 5. Capturing error logs from failed pods or deployments (CrashloopBackOff)
kubectl logs deploy "$DEPLOY" -n "$NS" --previous > /tmp/failed-logs.log
