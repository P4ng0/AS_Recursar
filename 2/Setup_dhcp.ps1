# ==========================================================
# SCRIPT DE CONFIGURACIÓN DHCP - PRÁCTICA 2
# ==========================================================

# 1. Verificación e Instalación del Rol (Idempotencia)
Write-Host "Verificando el rol DHCP..." -ForegroundColor Cyan
if (!(Get-WindowsFeature DHCP).Installed) {
    Install-WindowsFeature DHCP -IncludeManagementTools
    Write-Host "Rol DHCP instalado correctamente." -ForegroundColor Green
} else {
    Write-Host "El rol DHCP ya está presente en el sistema." -ForegroundColor Yellow
}

# 2. Captura de Datos (Interactividad simétrica a Linux)
Write-Host "`n--- Configuración de Ámbito DHCP ---" -ForegroundColor White
$ScopeName = Read-Host "Ingrese el nombre del Ámbito (ej. Red_Sistemas)"
$StartIP   = Read-Host "Ingrese la IP inicial del rango (ej. 192.168.100.50)"
$EndIP     = Read-Host "Ingrese la IP final del rango (ej. 192.168.100.150)"
$Gateway   = Read-Host "Ingrese la Puerta de Enlace (ej. 192.168.100.1)"

# DNS fijo para mantener vínculo con la Práctica 1
$DnsServer = "192.168.10.10"

# 3. Aplicación de Configuración
try {
    # Crear el ámbito con máscara /24
    Add-DhcpServerv4Scope -Name $ScopeName -StartRange $StartIP -EndRange $EndIP -SubnetMask 255.255.255.0 -State Active
    
    # Configurar opciones de Gateway (003) y DNS (006)
    Set-DhcpServerv4OptionValue -OptionId 3 -Value $Gateway
    Set-DhcpServerv4OptionValue -OptionId 6 -Value $DnsServer
    
    Write-Host "`n[ÉXITO] Servidor configurado y activo para el ámbito: $ScopeName" -ForegroundColor Green
} catch {
    Write-Host "`n[AVISO] El ámbito ya existe o los parámetros son inválidos. No se realizaron cambios." -ForegroundColor Yellow
}

# 4. Resumen de Estado
Write-Host "`n=== ESTADO FINAL DEL SERVICIO ===" -ForegroundColor Cyan
Get-Service dhcpserver | Select-Object Name, Status
Get-DhcpServerv4Scope | Select-Object ScopeId, Name, State