# 1. Instalación Idempotente
Write-Host "Verificando el rol DHCP..." -ForegroundColor Cyan
if (!(Get-WindowsFeature DHCP).Installed) {
    Install-WindowsFeature DHCP -IncludeManagementTools
    Write-Host "Rol DHCP instalado correctamente." -ForegroundColor Green
} else {
    Write-Host "El rol DHCP ya está presente." -ForegroundColor Yellow
}

# 2. Orquestación de Configuración (Valores solicitados por la práctica)
$ScopeName = "Ambito_Sistemas_Windows"
$StartIP = "192.168.100.50"
$EndIP = "192.168.100.150"
$Gateway = "192.168.100.1"
$DnsServer = "192.168.10.10" # IP de tu Práctica 1

# Intentar crear el ámbito (Scope)
try {
    Add-DhcpServerv4Scope -Name $ScopeName -StartRange $StartIP -EndRange $EndIP -SubnetMask 255.255.255.0 -State Active
    # Configurar opciones de Gateway (3) y DNS (6)
    Set-DhcpServerv4OptionValue -OptionId 3 -Value $Gateway
    Set-DhcpServerv4OptionValue -OptionId 6 -Value $DnsServer
    Write-Host "Ámbito '$ScopeName' creado y activado." -ForegroundColor Green
} catch {
    Write-Host "Aviso: El ámbito ya existe o los parámetros son inválidos." -ForegroundColor Yellow
}

# 3. Módulo de Monitoreo
Write-Host "`n=== ESTADO DEL SERVICIO ===" -ForegroundColor Cyan
Get-Service dhcpserver | Select-Object Name, Status

Write-Host "`n=== RESUMEN DEL ÁMBITO ===" -ForegroundColor Cyan
Get-DhcpServerv4Scope | Select-Object ScopeId, Name, State