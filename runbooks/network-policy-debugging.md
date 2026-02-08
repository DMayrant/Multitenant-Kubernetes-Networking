# Network Policy debugging RunBook 📝

Network policies control east-west traffic by preventing lateral movement from attack vectors 

Step 1. Establish default deny-all Ingress and Egress ensuring zero-trust 🛡️

If network policy does not work when applied

```bash
kubectl get netpol -n <ns>
```
check pod labels 

```bash
kubectl get deploy <deployment> -n <ns> --show-labels 
```

Step 2. Check if youre using a CNI 

- Calico
- Weave Net
- Cilnium
- Kube-Router
  
```bash
kubectl describe node 
```

Step 3. Applications need coredns for DNS resolution and Network policies only have an effect on resources in the namespace theyre applied in  

Validate DNS on UPD/TCP 53 ✅

```bash 
kubectl exec -it <curl-pod-name> -n ns -- sh
```
# 

```bash 
cat /etc/resolv.conf
```
Step 4. Internal service discovery and service to service communication ✉️

Network policies should allow egress on TCP 80

```bash 
kubectl exec -it <curl-pod-name> -n ns -- sh
```
# 

```bash
curl <service-name>.<ns>.svc.cluster.local:80
```
