# IMS Kubernetes Deployment Guide

## Quick Start

### 1. Deploy IMS Infrastructure
```bash
cd ~/challenge2/kubernetes
./deploy-ims.sh
```

### 2. Create ConfigMaps
```bash
./create-configmaps.sh
```

### 3. Initialize MySQL Databases
```bash
./init-mysql-databases.sh
```

### 4. Monitor Deployment
```bash
kubectl get pods -n ims -w
```

## Available Aliases

```bash
# Deployment
k8s-deploy-ims          # Deploy IMS to Kubernetes
k8s-create-configs      # Create ConfigMaps
k8s-init-mysql          # Initialize MySQL databases

# Monitoring
k8s-ims-status          # Get all IMS resources
k8s-ims-pods            # List IMS pods
k8s-ims-watch           # Watch pods in real-time

# Debugging
k8s-logs <pod-name>     # View pod logs
k8s-exec <pod-name>     # Execute commands in pod
k8s-describe <resource> # Describe resource

# Cleanup
k8s-delete-ims          # Delete IMS namespace
```

## Services

- **MySQL**: `mysql.ims.svc.cluster.local:3306`
- **MongoDB**: `mongo.ims.svc.cluster.local:27017`
- **HSS**: `hss.ims.svc.cluster.local:3868`
- **PCRF**: `pcrf.ims.svc.cluster.local:3868`
- **P-CSCF**: `pcscf.ims.svc.cluster.local:5060`
- **I-CSCF**: `icscf.ims.svc.cluster.local:4060`
- **S-CSCF**: `scscf.ims.svc.cluster.local:6060`

## Troubleshooting

### Check pod status
```bash
kubectl get pods -n ims
kubectl describe pod <pod-name> -n ims
kubectl logs <pod-name> -n ims
```

### Access MySQL
```bash
kubectl exec -it deployment/mysql -n ims -- mysql -u root -plinux
```

### Verify databases
```bash
kubectl exec deployment/mysql -n ims -- mysql -u root -plinux -e "SHOW DATABASES;"
```
