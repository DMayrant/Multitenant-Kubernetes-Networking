## Incident Response Run Book 📖

The highest priority is containing the blast radius and ensuring other workloads in the namespace are not compromised 

Step 1. Check logs 🔍

```bash 
kubectl get pods -n <ns> 
```

```bash 
kubectl describe <pod-name> -n <ns>
```

```bash 
kubectl logs deploy/<deployment-name> -n <ns>
```

```bash 
kubectl logs -f <pod> -n <ns>
```

If YAML ❗️ access isn't readily available 

```bash 
kubectl get pod -n <namespace> -o yaml
```

Step 2. Minimize downtime and Containment ☣️

```bash 
kubectl scale deploy <deployment> -n <ns> --replicas=2
```

```bash 
kubectl rollout undo deploy <deployment> -n <ns>
```
Double check logs and deployment status

```bash
kubectl rollout history deploy <deployment> -n <ns> 
```
```bash 
kubectl logs deploy/<deployment> -n <ns>
```
Step 3. Record change cause (Operational traceability)📚 

Annotate 📝 if any changes are made

```bash 
kubectl annotate deploy <deployment> -n <ns> kubernetes.io/change-cause="<change-description>"
```

Overwrite 🖋️ an existing change-cause annotation 

```bash 
kubectl annotate deploy <deployment> -n <ns> kubernetes.io/change-cause="<overwrite-message>" --overwrite
```
Step 4. Health checks ✅

```bash 
kubectl get deploy <deployment> -n <ns> -o wide" 
```

```bash 
kubectl get pod <pod-name> -n <ns> -o wide" 
```
Step 5. Capturing error logs from failed pods or deployments (CrashloopBackOff)

```bash 
kubectl logs deploy/<deployment> -n <ns> --previous > /tmp/failed-logs.log