# Makefile para facilitar comandos comuns

.PHONY: help install-tools validate scan deploy clean

help: ## Exibe esta mensagem de ajuda
	@echo "Comandos disponíveis:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

install-tools: ## Instala ferramentas necessárias (trivy, kubeconform, kube-score, pre-commit)
	@echo "Instalando ferramentas..."
	@command -v trivy >/dev/null 2>&1 || (echo "Instalando Trivy..." && curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin)
	@command -v kubeconform >/dev/null 2>&1 || (echo "Instalando kubeconform..." && go install github.com/yannh/kubeconform/cmd/kubeconform@latest)
	@command -v kube-score >/dev/null 2>&1 || (echo "Instalando kube-score..." && go install github.com/zegl/kube-score/cmd/kube-score@latest)
	@command -v pre-commit >/dev/null 2>&1 || (echo "Instalando pre-commit..." && pip install pre-commit)
	@echo "Instalando hooks do pre-commit..."
	@pre-commit install
	@echo "✓ Ferramentas instaladas com sucesso!"

validate: ## Valida todos os manifests YAML
	@echo "Validando sintaxe YAML..."
	@yamllint .
	@echo "Validando schemas Kubernetes..."
	@kubeconform -strict -summary *.yaml
	@echo "Validando Kustomization..."
	@kubectl kustomize . > /dev/null
	@echo "✓ Validação concluída!"

scan: ## Executa scan de segurança com Trivy
	@echo "Escaneando configurações com Trivy..."
	@trivy config --config trivy.yaml .
	@echo "Escaneando filesystem..."
	@trivy fs --severity HIGH,CRITICAL --scanners misconfig,secret .
	@echo "✓ Scan concluído!"

best-practices: ## Verifica best practices com kube-score
	@echo "Verificando best practices..."
	@kube-score score *.yaml --output-format ci || true
	@echo "✓ Verificação concluída!"

pre-commit: ## Executa todos os hooks do pre-commit
	@echo "Executando pre-commit hooks..."
	@pre-commit run --all-files
	@echo "✓ Pre-commit concluído!"

build: validate scan best-practices ## Valida, escaneia e verifica best practices

test-kustomize: ## Testa a geração do Kustomize
	@echo "Testando Kustomize..."
	@kubectl kustomize . | head -20
	@echo "✓ Kustomize OK!"

deploy: ## Aplica os manifests no cluster
	@echo "Aplicando manifests..."
	@kubectl apply -k .
	@echo "✓ Deploy concluído!"

deploy-argocd: ## Cria application no ArgoCD
	@echo "Criando ArgoCD Application..."
	@kubectl apply -f app.yaml
	@echo "✓ ArgoCD Application criado!"

status: ## Verifica status dos recursos
	@echo "Status dos recursos no namespace dev:"
	@kubectl get all -n dev
	@kubectl get scaledobject -n dev
	@kubectl get pdb -n dev

logs: ## Exibe logs do deployment
	@kubectl logs -n dev -l app=keda-kafka-consumer --tail=50 -f

clean: ## Remove recursos do cluster
	@echo "Removendo recursos..."
	@kubectl delete -k . --ignore-not-found=true
	@echo "✓ Recursos removidos!"

clean-argocd: ## Remove ArgoCD Application
	@echo "Removendo ArgoCD Application..."
	@kubectl delete -f app.yaml --ignore-not-found=true
	@echo "✓ ArgoCD Application removido!"
