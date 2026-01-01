# Script para manter port-forward permanente do Policy Reporter UI
# Executa em loop infinito e reconecta automaticamente se desconectar

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Policy Reporter UI - Port Forward Permanente" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Acesse: http://localhost:8082" -ForegroundColor Green
Write-Host "Pressione Ctrl+C para parar" -ForegroundColor Yellow
Write-Host ""

$attempt = 1

while ($true) {
    try {
        Write-Host "[$attempt] Iniciando port-forward..." -ForegroundColor Cyan

        # Executa port-forward
        kubectl port-forward -n policy-reporter svc/policy-reporter-ui 8082:8080

        # Se chegou aqui, o port-forward foi interrompido
        Write-Host "Port-forward interrompido. Reconectando em 5 segundos..." -ForegroundColor Yellow
        Start-Sleep -Seconds 5

    } catch {
        Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Tentando novamente em 10 segundos..." -ForegroundColor Yellow
        Start-Sleep -Seconds 10
    }

    $attempt++
}
