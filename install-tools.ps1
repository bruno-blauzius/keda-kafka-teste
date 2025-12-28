# Instalacao das Ferramentas de Validacao (Windows)

Write-Host "Instalando ferramentas de validacao..." -ForegroundColor Green

# Instalar Trivy
Write-Host "`nInstalando Trivy..." -ForegroundColor Yellow
if (!(Get-Command trivy -ErrorAction SilentlyContinue)) {
    choco install trivy -y
} else {
    Write-Host "Trivy ja esta instalado" -ForegroundColor Cyan
}

# Instalar yamllint via pip
Write-Host "`nInstalando yamllint..." -ForegroundColor Yellow
if (!(Get-Command yamllint -ErrorAction SilentlyContinue)) {
    pip install yamllint
} else {
    Write-Host "yamllint ja esta instalado" -ForegroundColor Cyan
}

# Instalar pre-commit
Write-Host "`nInstalando pre-commit..." -ForegroundColor Yellow
if (!(Get-Command pre-commit -ErrorAction SilentlyContinue)) {
    pip install pre-commit
} else {
    Write-Host "pre-commit ja esta instalado" -ForegroundColor Cyan
}

# Instalar gitleaks
Write-Host "`nInstalando gitleaks..." -ForegroundColor Yellow
if (!(Get-Command gitleaks -ErrorAction SilentlyContinue)) {
    choco install gitleaks -y
} else {
    Write-Host "gitleaks ja esta instalado" -ForegroundColor Cyan
}

Write-Host "`nInstalacao concluida!" -ForegroundColor Green
Write-Host "`nInstalando pre-commit hooks..." -ForegroundColor Yellow
pre-commit install

Write-Host "`nFerramentas instaladas com sucesso!" -ForegroundColor Green
Write-Host "`nProximos passos:" -ForegroundColor Yellow
Write-Host "1. Reinicie o terminal" -ForegroundColor White
Write-Host "2. Execute: pre-commit run --all-files" -ForegroundColor White
Write-Host "3. Execute: trivy config ." -ForegroundColor White
