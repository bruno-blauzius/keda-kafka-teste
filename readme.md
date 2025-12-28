## Make

### Create Namespace
```bash
kubectl create namespace argocd
```


### Install Argo CD
```bash
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Verify your installation
```bash
kubectl get pods -n argocd
```

### Access in your Localhost
Apply port-forward:
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Access:
```bash
https://localhost:8080
```

Access Painel:
```bash
#root user
user: admin

#apply code get initial password
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
```

# Create Project Kubernets ON GITHUB

```yaml

```


# Install Keda

Keda
[Documentation](https://keda.sh/docs/2.18/setupscaler/#prerequisites)

```bash
#install keda
kubectl apply -f https://github.com/kedacore/keda/releases/download/v2.12.0/keda-2.12.0.yaml
```
### Verify installation
```bash
# pass one
kubectl get scaledobject -n dev

# pass two
kubectl get hpa -n dev

#pass tree
kubectl describe scaledobject nginx-view-scaler -n dev

#pass four
kubectl get pods -n dev
```
install metrics
```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

# Instalação do Kyverno usando kubectl
Kyverno [Documentation](https://kyverno.io/docs/policy-types/cluster-policy/validate/)

### Apply the oficial manifest

```bash
kubectl apply -f https://github.com/kyverno/kyverno/releases/latest/download/install.yaml
```

### Verify Kyverno Instalation
```bash
kubectl get pods -n kyverno

# Outputs
- kyverno-admission-controller
- kyverno-background-controller
- kyverno-cleanup-controller
```


