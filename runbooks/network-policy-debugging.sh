#!/bin/bash 
set -euo pipefail 

NS="team-a"
DEPLOY="team-a-app"
POD="nginx"
CURL="curl"
SVC="team-a-app"

#Network Policy debugging RunBook 📝
#Network policies control east-west traffic by preventing lateral movement from attack vectors 

# Step 1. Establish default deny-all Ingress and Egress ensuring zero-trust 🛡️
# If network policy does not work when applied
kubectl get netpol -n "$NS"

# check pod labels 
kubectl get deploy/"$DEPLOY" -n "$NS" --show-labels 

#Step 2. Check if your'e using a CNI, Calico, Flannel, Weave Net or Cilinum
# Check node ✅ 
kubectl get nodes -o wide
kubectl get pods -n kube-system -o wide  

# Step 3. Applications need coredns for DNS resolution and Network policies only have an effect on resources in the namespace theyre applied in  

# Validate DNS on UPD/TCP 53 ✅
kubectl exec -it "$CURL" -n "$NS" -- cat /etc/resolv.conf

# Step 4. Internal service discovery and service to service communication ✉️

# Network policies should allow egress on TCP 80
kubectl exec -it "$CURL" -n "$NS" -- curl "$SVC"."$NS".svc.cluster.local:80

#Check events and pods and netpol ✅ 
kubectl get events -n "$NS" --sort-by=.lastTimestamp | tail -n 30
kubectl get pods -n "$NS" -o wide
kubectl describe netpol -n "$NS"
