# Kafka KEDA Scaled Consumer

Este projeto contém os manifestos Kubernetes para um consumidor Kafka
esclado automaticamente com KEDA.

## 📋 Pré-requisitos

- Kubernetes cluster (1.19+)
- kubectl configurado
- KEDA instalado no cluster
- ArgoCD (opcional, para deployment automatizado)
- Ferramentas de validação:
  - trivy
  - kubeconform
  - kube-score
  - yamllint
  - pre-commit

## 🚀 Quick Start

### Instalação das Ferramentas (Windows)

```powershell
# Executar como Administrador
.\install-tools.ps1
```

Ou instalar manualmente:

```powershell
# Trivy
choco install trivy -y

# Python tools
pip install yamllint pre-commit

# Gitleaks
choco install gitleaks -y
```

### Validação e Testes

```bash
# Validar YAML
yamllint .

# Validar schemas Kubernetes
kubeconform -strict *.yaml

# Scan de segurança com Trivy
trivy config --config trivy.yaml .

# Best practices
kube-score score *.yaml --output-format ci

# Executar todos os checks do pre-commit
pre-commit run --all-files
```

### Deploy

#### Opção 1: Deploy direto com kubectl

```bash
# Aplicar manifests
kubectl apply -k .

# Verificar status
kubectl get all -n dev

# Ver logs
kubectl logs -n dev -l app=keda-kafka-consumer -f
```

#### Opção 2: Deploy com ArgoCD

```bash
# Criar ArgoCD Application
kubectl apply -f app.yaml
```

## 📁 Estrutura do Projeto

```text
.
├── namespace.yaml              # Namespace dev
├── secret.yaml                 # Configurações Kafka (base64)
├── deployment.yaml             # Deployment do consumidor
├── service.yaml                # Service ClusterIP
├── keda-scaledobject.yaml      # Configuração KEDA para autoescaling
├── poddisruptionbudget.yaml    # PDB para alta disponibilidade
├── kustomization.yaml          # Kustomize configuration
├── app.yaml                    # ArgoCD Application
├── .pre-commit-config.yaml     # Pre-commit hooks
├── .yamllint.yaml              # Configuração yamllint
├── trivy.yaml                  # Configuração Trivy
└── install-tools.ps1           # Script instalação ferramentas (Windows)
```

## 🔒 Segurança

### Pre-commit Hooks

O projeto usa pre-commit para validações automáticas:

```bash
# Instalar hooks
pre-commit install

# Executar manualmente
pre-commit run --all-files
```

Hooks configurados:

- ✅ Trivy security scanning
- ✅ YAML syntax validation
- ✅ Kubernetes manifest validation (kubeconform)
- ✅ Best practices check (kube-score)
- ✅ Secret detection (gitleaks)
- ✅ Kustomize validation

### Scan de Segurança

```bash
# Scan completo com Trivy
trivy config --config trivy.yaml .

# Scan de secrets
trivy fs --scanners secret .

# Scan de vulnerabilidades na imagem
trivy image bruno01/keda-kafka:01
```

## 🔧 Configuração

### Secrets

Os secrets estão em base64 no arquivo `secret.yaml`. Para alterar:

```powershell
# Windows PowerShell - Encode
$text = "novo-valor"
[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($text))

# Decode
$base64 = "bG9jYWxob3N0OjI5MDky"
[System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($base64))
```

### KEDA Scaling

Configuração atual em `keda-scaledobject.yaml`:

- **Min replicas**: 1
- **Max replicas**: 10
- **Lag threshold**: 10 mensagens
- **Polling interval**: 30s
- **Cooldown**: 300s

## 📊 Monitoramento

```bash
# Status geral
kubectl get all -n dev

# KEDA ScaledObject
kubectl get scaledobject -n dev

# HPA criado pelo KEDA
kubectl get hpa -n dev

# Logs do consumidor
kubectl logs -n dev -l app=keda-kafka-consumer -f
```

## 🔄 CI/CD com ArgoCD

### Criar Namespace ArgoCD

```bash
kubectl create namespace argocd
```

### Instalar ArgoCD

```bash
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### Acessar ArgoCD UI

```bash
# Port-forward
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Acesso: <https://localhost:8080>

```bash
# User: admin
# Password:
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
```

### GitOps

O arquivo `app.yaml` configura:

- ✅ Sync automático
- ✅ Self-healing
- ✅ Prune de recursos órfãos
- ✅ Retry com backoff exponencial

### Pipeline Sugerido

```yaml
# .github/workflows/validate.yaml
- name: Validate manifests
  run: |
    yamllint .
    kubeconform -strict *.yaml

- name: Security scan
  run: trivy config --exit-code 1 .

- name: Best practices
  run: kube-score score *.yaml --output-format ci
```

## 📝 Boas Práticas Implementadas

- ✅ Secrets em base64
- ✅ SecurityContext (non-root, drop capabilities)
- ✅ Resource limits e requests
- ✅ Liveness e Readiness probes
- ✅ RollingUpdate strategy
- ✅ PodDisruptionBudget
- ✅ Labels e annotations padronizadas
- ✅ Namespace isolado
- ✅ Validação automática com pre-commit
- ✅ Security scanning com Trivy
- ✅ GitOps ready (ArgoCD)

## 🐛 Troubleshooting

### Pods não iniciam

```bash
kubectl describe pod -n dev -l app=keda-kafka-consumer
```

### KEDA não escala

```bash
kubectl logs -n keda deploy/keda-operator
kubectl describe scaledobject -n dev kafka-consumer-scaler
```

### Secret não encontrado

```bash
kubectl get secret -n dev kafka-config
kubectl describe secret -n dev kafka-config
```

## 🛠️ Instalação KEDA

```bash
# Adicionar repositório Helm
helm repo add kedacore https://kedacore.github.io/charts
helm repo update

# Instalar KEDA
helm install keda kedacore/keda --namespace keda --create-namespace
```

## 📚 Documentação

- [KEDA Documentation](https://keda.sh/)
- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)

## 🤝 Contribuindo

1. Fork o projeto
2. Instale os pre-commit hooks: `pre-commit install`
3. Faça suas alterações
4. Execute validações: `pre-commit run --all-files`
5. Commit e push
6. Abra um Pull Request
[Documentation](https://keda.sh/docs/2.18/setupscaler/#prerequisites)

```bash
#install keda
kubectl apply --server-side=true \
  -f https://github.com/kedacore/keda/releases/download/v2.16.0/keda-2.16.0.yaml
```

**Nota**: O parâmetro `--server-side=true` é necessário para contornar o
limite de 256KB nas anotações do CRD `scaledjobs.keda.sh`.

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

## Instalação do Kyverno

Kyverno [Documentation](https://kyverno.io/docs/installation/methods/#install-kyverno-using-yamls)

### Apply the oficial manifest

```bash
kubectl create -f https://github.com/kyverno/kyverno/releases/download/v1.16.0/install.yaml
# or
kubectl apply -f https://github.com/kyverno/kyverno/releases/latest/download/install.yaml
```

### Verify Kyverno Instalation

```bash
kubectl get pods -n kyverno

# Outputs
- kyverno-admission-controller
- kyverno-background-controller
- kyverno-cleanup-controller
- kyverno-reports-controller
```

## 📊 Visualização de Governança - Policy Reporter

Policy Reporter oferece visualização completa das políticas do Kyverno com
dashboards, gráficos e relatórios em tempo real.

### Instalação do Policy Reporter

```bash
# Adicionar repositório Helm
helm repo add policy-reporter https://kyverno.github.io/policy-reporter
helm repo update

# Instalar Policy Reporter com UI e plugin Kyverno
helm install policy-reporter policy-reporter/policy-reporter \
  --namespace policy-reporter \
  --create-namespace \
  --set ui.enabled=true \
  --set kyvernoPlugin.enabled=true \
  --set ui.plugins.kyverno=true \
  --set metrics.enabled=true
```

### Configurar Políticas em Modo Audit para Policy Reporter

Para evitar que as políticas do Kyverno bloqueiem a instalação do Policy Reporter:

```powershell
# Windows PowerShell
kubectl get clusterpolicies -o name | ForEach-Object {
  kubectl patch $_ --type='json' -p='[{
    "op": "add",
    "path": "/spec/validationFailureActionOverrides",
    "value": [{
      "action": "Audit",
      "namespaces": ["policy-reporter"]
    }]
  }]'
}
```

### Verificar Instalação

```bash
# Verificar pods
kubectl get pods -n policy-reporter

# Verificar serviços
kubectl get svc -n policy-reporter

# Ver logs
kubectl logs -n policy-reporter -l app.kubernetes.io/name=policy-reporter -f
```

### Acessar Policy Reporter UI

```bash
# Port-forward para acessar a interface web
kubectl port-forward -n policy-reporter svc/policy-reporter-ui 8082:8080
```

**Acesso**: <http://localhost:8082>

### Recursos da UI

- ✅ Dashboard com visão geral de todas as políticas
- ✅ Status de compliance em tempo real
- ✅ Gráficos de violações por namespace/política
- ✅ Filtros por severity (info, warning, error)
- ✅ Relatórios detalhados de cada recurso
- ✅ Tendências históricas de compliance
- ✅ Integração nativa com Kyverno

### Comandos Úteis - Policy Reporter

```bash
# Listar todos os Policy Reports
kubectl get policyreports -A

# Ver relatórios do namespace dev
kubectl get policyreport -n dev

# Detalhar um relatório específico
kubectl describe policyreport <report-name> -n dev

# Ver cluster-wide reports
kubectl get clusterpolicyreports

# Logs do Policy Reporter
kubectl logs -n policy-reporter -l app.kubernetes.io/name=policy-reporter -f

# Logs da UI
kubectl logs -n policy-reporter -l app.kubernetes.io/name=policy-reporter-ui -f

# Reiniciar Policy Reporter
kubectl rollout restart deployment -n policy-reporter

# Desinstalar Policy Reporter
helm uninstall policy-reporter -n policy-reporter
kubectl delete namespace policy-reporter
```

### Métricas Prometheus

Se você tem Prometheus instalado, o Policy Reporter exporta métricas:

```bash
# Endpoint de métricas
kubectl port-forward -n policy-reporter svc/policy-reporter 8080:8080

# Acessar métricas
curl http://localhost:8080/metrics
```

### Integração com Grafana

Importar dashboard oficial do Policy Reporter:

- **Dashboard ID**: 18223
- **URL**: <https://grafana.com/grafana/dashboards/18223>

```bash
# Se usar kube-prometheus-stack
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80
```
